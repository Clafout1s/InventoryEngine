extends Node2D

var constructed:bool = false
var blocked = false
var moving = false
var move_speed = 0
var tile_array:Array
var tile_data:TileGenerationData
var active_scene:Node2D
var selected_tile:TileContainer
var pickedItem=null

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
		first.add_item(preload("res://InventoryItem.tscn"))
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
	pick_item(selected_tile)

func right_click_function(_delta):
	selected_tile.add_item(preload("res://InventoryItem.tscn"))
	
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
		"""
		if pickedItem != null:
			pickedItem.position = selected_tile.position
		"""

func pick_item(tile:TileContainer):
	if tile is TileContainer:
		if pickedItem != null:
			if tile.content == null:
				self.remove_child(pickedItem)
				land_item(pickedItem)
				tile.add_child(pickedItem)
				tile.content = pickedItem
				
				pickedItem = null
			else:
				$SwapItem.play()
				tile.remove_child(tile.content)
				self.remove_child(pickedItem)
				land_item(pickedItem)
				tile.add_child(pickedItem)
				var tempo = pickedItem
				pickedItem = tile.content
				tile.content = tempo
				self.add_child(pickedItem)
				hover_item(pickedItem)
				
		else:
			if tile.content != null:
				pickedItem = tile.content
				tile.remove_child(tile.content)
				tile.content = null
				self.add_child(pickedItem)
				hover_item(pickedItem)

func animations_process(_delta):
	if moving:
		if pickedItem == null:
			moving = false
		else:
			move_speed+= _delta * 2.5
			var lerp_move = pickedItem.position.lerp(selected_tile.position,move_speed )
			pickedItem.position = lerp_move
			print(lerp_move)
			if pickedItem.position.round() == selected_tile.position.round():
				moving = false
				
		

func move_animation_start(_delta):
	moving = true
	move_speed = 0 
	$MoveSelect.play()

func hover_item(item:Node2D):
	item.scale += Vector2(0.1,0.1)
	item.modulate.a = 0.9
	item.position = selected_tile.position
	$PickItem.play()

func land_item(item:Node2D):
	item.modulate.a = 1
	item.scale -= Vector2(0.1,0.1)
	item.position = Vector2(0,0)
	$DropItem.play()
