class_name TilesManager extends Node2D
## This class act as an interface to interact with all the Tiles of a scene.
## It listens and reacts to player input, and contains all the tile based functionality of a game.
## Different games should have different [TilesManager] instances.
## This one is the common base to the others, and handles an inventory system.


## Boolean for the custom constructor.
var constructed:bool = false

## Used to block all player inputs if needed.
var blocked = false

## Used to detect if an animation is in action.
var moving = false

## This stores the moving speed of travel between tiles during an animation.
var move_speed = 0

## The array of array containing all tiles handled by the Manager.
var tile_array:Array

## The [TileGenerationData] used by the [Generator] for this Manager, if needed.
var tile_data:TileGenerationData

## The parent scene of the Manager, where the tiles are drawn.
var active_scene:Node2D

## The tile that the player is on.
var selected_tile:TileContainer

## The array of items picked up for moving.
var pickedItems:Array=[]

func _ready():
	#$LabelCounter.position = tile_array[0].get_node("Label").position
	pass

## The core of the loop. Coded such as it shouldn't need overriding in child classes.
func _physics_process(_delta):
	if constructed and not blocked and not moving:
		if Input.is_action_pressed("up"):
			up_key_function(_delta)
		if Input.is_action_pressed("down"):
			down_key_function(_delta)
		if Input.is_action_pressed("left"):
			left_key_function(_delta)
		if Input.is_action_pressed("right"):
			right_key_function(_delta)
		if Input.is_action_just_pressed("leftClick"):
			left_click_function(_delta)
		if Input.is_action_just_pressed("rightClick"):
			right_click_function(_delta)
	animations_process(_delta)

## A self made constructor, that [b] must [/b] be called when an instance of [TilesManager] is created.
func constructor(scene:Node2D,tile_array:Array,tile_data:TileGenerationData):
	self.tile_array = tile_array
	self.tile_data = tile_data
	self.active_scene = scene
	
	# Selects the first tile possible to the player
	var first:TileContainer = find_first_container_tile()
	if(first != null):
		first.select_tile()
		selected_tile = first
	var rng = RandomNumberGenerator.new()
	
	# Sprinkle random items in the tiles
	for i in range(tile_array.size()):
		for y in range(tile_array[i].size()):
			if rng.randf() >= 2./3.:
				if tile_array[i][y] is TileContainer:
					tile_array[i][y].add_item(preload("res://InventoryItem.tscn").instantiate())
	
	# Initialize LabelCounter, which counts and show picked items number.
	$LabelCounter.position = tile_array[0][0].get_node("Label").global_position
	$LabelCounter.scale = tile_array[0][0].get_node("Label").scale * tile_array[0][0].scale
	constructed = true
	return self

## Returns the first [TileContainer] in the tiles_array.
func find_first_container_tile()->TileContainer:
	var result:TileContainer
	var line:int = 0
	var column:int = 0
	var max_line = len(tile_array)
	var max_column = len(tile_array[line])
	while(result==null and line < max_line-1):
		if tile_array[line][column] is TileContainer:
			result = tile_array[line][column]
		column+=1
		if column >= max_column+1:
			line+=1
			max_column = len(tile_array[line])
			column = 0
	return result

## A generic function that is called when left click key is pressed.
func left_click_function(_delta):
	pick_items(selected_tile)

## A generic function that is called when right click key is pressed.
func right_click_function(_delta):
	pass

## A generic function that is called when left key is pressed.
func left_key_function(_delta):
	if button_spam_cooldown():
		move_animation_start(_delta)
		select_tile(selected_tile.next_left())

## A generic function that is called when right key is pressed.
func right_key_function(_delta):
	if button_spam_cooldown():
		move_animation_start(_delta)
		select_tile(selected_tile.next_right())

## A generic function that is called when up key is pressed.
func up_key_function(_delta):
	if button_spam_cooldown():
		move_animation_start(_delta)
		select_tile(selected_tile.next_up())

## A generic function that is called when down key is pressed.
func down_key_function(_delta):
	if button_spam_cooldown():
		move_animation_start(_delta)
		select_tile(selected_tile.next_down())

## Makes sure that leaving the same key pressed doesn't lead to spam.
func button_spam_cooldown()->bool:
	if $ButtonSpamCd.is_stopped():
		$ButtonSpamCd.start()
		return true
	else:
		return false

## Select [param new_tile] as the new selected tile.
func select_tile(new_tile:TileContainer):
	if new_tile is TileContainer:
		$MoveSelect.play()
		selected_tile.unselect_tile()
		new_tile.select_tile()
		selected_tile = new_tile
		if pickedItems == []:
			$LabelCounter.position = new_tile.get_node("Label").global_position

## Handles the picking, dropping and swapping of items between [param tile] and [member pickedItems].
func pick_items(tile:TileContainer):
	if tile is TileContainer:
		if pickedItems != []:
			# Drop picked items
			if tile.content == [] or tile.content[0].equals(pickedItems[0]):
				var last_picked_item
				while pickedItems != []:
					last_picked_item = pickedItems.pop_back()
					if pickedItems == []:
						land_item(last_picked_item,tile)
						self.remove_child(last_picked_item)
					tile.add_item(last_picked_item)
			else:
				# Swap items
				$SwapItem.play()
				var last_tile_content
				var temporary_array = []
				for i_tile in range(tile.content.size()):
					temporary_array.push_front(tile.remove_item()) # pushing front to preserve order
				for i_picked in range(pickedItems.size()):
					var last_picked_item = pickedItems.pop_front()
					if(i_picked == 0):
						self.remove_child(last_picked_item)
						land_item(last_picked_item,tile)
					tile.add_item(last_picked_item) # popping front to preserve order
				for i_tempo in range(temporary_array.size()):
					var last_tempo_item = temporary_array.pop_back()
					if(i_tempo == 0):
						self.add_child(last_tempo_item)
						hover_item(last_tempo_item,tile)
					pickedItems.push_back(last_tempo_item)
			
		else:
			if tile.content != []:
				# Pick items
				var last_tile_content
				for i in range(tile.content.size()):
					last_tile_content = tile.remove_item()
					if i == 0:
						self.add_child(last_tile_content)
						hover_item(last_tile_content,tile)
					pickedItems.push_back(last_tile_content)

		# LabelCounter changes
		if pickedItems.size() > 1:
			$LabelCounter.visible = true
			$LabelCounter.text = String.num(pickedItems.size())
			$LabelCounter.modulate.a = 1
		else:
			$LabelCounter.visible = false

## Is called each frame to make the [member pickedItem] move by interpolation.
func animations_process(_delta):
	if moving:
		if pickedItems == []:
			moving = false
		else:
			move_speed+= _delta * 2.5
			var lerp_move = pickedItems[0].position.lerp(selected_tile.position,move_speed)
			pickedItems[0].position = lerp_move
			$LabelCounter.position = $LabelCounter.position.lerp(selected_tile.get_node("Label").global_position,move_speed)
			if pickedItems[0].position.round() == selected_tile.position.round():
				moving = false

## Resets and launches the animation.
func move_animation_start(_delta):
	moving = true
	move_speed = 0 
	
## Make the [param item] hover before the [param tile].
func hover_item(item:Node2D,tile:TileContainer):
	item.scale *= tile.scale
	item.modulate.a = 0.9
	move_child($LabelCounter,-1)
	item.position = selected_tile.position
	$PickItem.play()

## Make the [param item] land in the level of the [param tile].
func land_item(item:Node2D,tile:TileContainer):
	item.modulate.a = 1
	item.scale /= tile.scale
	item.position = Vector2(0,0)
	$DropItem.play()
