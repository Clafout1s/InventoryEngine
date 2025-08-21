extends Node2D

var constructed:bool = false
var blocked = false
var moving = false
var move_speed = 0
var tile_array:Array
var tile_data:TileGenerationData
var active_scene:Node2D
var selected_tile:TileContainer
var pickedItems:Array=[]

func _ready():
	#$LabelCounter.position = tile_array[0].get_node("Label").position
	pass

func _physics_process(_delta):
	if constructed and not blocked and not moving:
		if Input.is_action_just_pressed("up"):
			up_key_function(_delta)
		if Input.is_action_just_pressed("down"):
			down_key_function(_delta)
		if Input.is_action_just_pressed("left"):
			left_key_function(_delta)
		if Input.is_action_just_pressed("right"):
			right_key_function(_delta)
		if Input.is_action_just_pressed("leftClick"):
			left_click_function(_delta)
		if Input.is_action_just_pressed("rightClick"):
			right_click_function(_delta)
	animations_process(_delta)
	
func constructor(scene:Node2D,tile_array:Array,tile_data:TileGenerationData):
	self.tile_array = tile_array
	self.tile_data = tile_data
	self.active_scene = scene
	var first:TileContainer = find_first_container_tile()
	if(first != null):
		first.select_tile()
		selected_tile = first
		first.add_item(preload("res://InventoryItem.tscn").instantiate())
	var rng = RandomNumberGenerator.new()
	for i in range(tile_array.size()):
		for y in range(tile_array.size()):
			if rng.randf() >= 2./3.:
				tile_array[i][y].add_item(preload("res://InventoryItem.tscn").instantiate())
	$LabelCounter.position = tile_array[0][0].get_node("Label").global_position
	constructed = true
	return self

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

func left_click_function(_delta):
	pick_items(selected_tile)

func right_click_function(_delta):
	if selected_tile.content == []:
		selected_tile.add_item(preload("res://InventoryItem.tscn").instantiate())
	
func left_key_function(_delta):
	move_animation_start(_delta)
	select_tile(selected_tile.next_left())

func right_key_function(_delta):
	move_animation_start(_delta)
	select_tile(selected_tile.next_right())

func up_key_function(_delta):
	move_animation_start(_delta)
	select_tile(selected_tile.next_up())

func down_key_function(_delta):
	move_animation_start(_delta)
	select_tile(selected_tile.next_down())

func select_tile(new_tile:TileContainer):
	if new_tile is TileContainer:
		selected_tile.unselect_tile()
		new_tile.select_tile()
		selected_tile = new_tile
		if pickedItems == []:
			$LabelCounter.position = new_tile.get_node("Label").global_position

func pick_items(tile:TileContainer):
	if tile is TileContainer:
		if pickedItems != []:
			# Drop picked items
			if tile.content == [] or tile.content[0].equals(pickedItems[0]):
				var last_picked_item
				while pickedItems != []:
					last_picked_item = pickedItems.pop_back()
					if pickedItems == []:
						land_item(last_picked_item)
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
						land_item(last_picked_item)
					tile.add_item(last_picked_item) # popping front to preserve order
				for i_tempo in range(temporary_array.size()):
					var last_tempo_item = temporary_array.pop_back()
					if(i_tempo == 0):
						self.add_child(last_tempo_item)
						hover_item(last_tempo_item)
					pickedItems.push_back(last_tempo_item)
			
		else:
			if tile.content != []:
				# Pick items
				var last_tile_content
				for i in range(tile.content.size()):
					last_tile_content = tile.remove_item()
					if i == 0:
						self.add_child(last_tile_content)
						hover_item(last_tile_content)
					pickedItems.push_back(last_tile_content)

		if pickedItems.size() > 1:
			$LabelCounter.visible = true
			$LabelCounter.text = String.num(pickedItems.size())
			$LabelCounter.modulate.a = 1
		else:
			$LabelCounter.visible = false

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

func move_animation_start(_delta):
	moving = true
	move_speed = 0 
	$MoveSelect.play()

func hover_item(item:Node2D):
	item.scale += Vector2(0.1,0.1)
	item.modulate.a = 0.9
	move_child($LabelCounter,-1)
	item.position = selected_tile.position
	$PickItem.play()

func land_item(item:Node2D):
	item.modulate.a = 1
	item.scale -= Vector2(0.1,0.1)
	item.position = Vector2(0,0)
	$DropItem.play()
