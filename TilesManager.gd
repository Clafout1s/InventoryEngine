extends Node2D

var constructed:bool = false
var tile_array:Array
var tile_data:TileGenerationData
var active_scene:Node2D
var selected_tile:TileContainer

func _ready():
	pass

func constructor(scene:Node2D,tile_array:Array,tile_data:TileGenerationData):
	self.tile_array = tile_array
	self.tile_data = tile_data
	self.active_scene = scene
	var first:TileContainer = find_first_container_tile()
	if(first != null):
		first.select_tile()
		selected_tile = first
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
		
func _process(_delta):
	if constructed:
		var new_tile:TileContainer
		if Input.is_action_just_pressed("up"):
			new_tile = selected_tile.next_up()
		if Input.is_action_just_pressed("down"):
			new_tile = selected_tile.next_down()
		if Input.is_action_just_pressed("left"):
			new_tile = selected_tile.next_left()
		if Input.is_action_just_pressed("right"):
			new_tile = selected_tile.next_right()
		
		if(new_tile is TileContainer):
			selected_tile.unselect_tile()
			new_tile.select_tile()
			selected_tile = new_tile
				
			
		
