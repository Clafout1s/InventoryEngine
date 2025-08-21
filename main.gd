extends Node2D
## The starter scene, to begin the creation of tiles

var tile_container_scene = preload("res://TileContainer.tscn")
var tile_void_scene = preload("res://TileVoid.tscn")

func _ready():
	var generator = Generator.new()
	var teststr = " 0 0 0 0 0 0 0 0 0
	0 0 0 0 X X X 0 
	0 X 0 0 X 0 0 0 
	0 0 0 0 0 X X 0" 
	var data = TileGenerationData.new(teststr,20,500,preload("res://images/tileContainer.png"),preload("res://images/tileContainerSelected.png"))
	generator.generate_tiles(self,data)

