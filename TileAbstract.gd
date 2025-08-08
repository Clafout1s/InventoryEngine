extends Node2D

class_name TileAbstract

var up:TileAbstract
var down:TileAbstract
var left:TileAbstract
var right:TileAbstract
var texture_size:int = 128

func _ready():
	pass
	
func load_sprites(sprite_normal:CompressedTexture2D,sprite_selected:CompressedTexture2D):
	pass

func _to_string():
	return "TileAbstract"

func verify_texture_size():
	assert(has_node("Sprite2D") and get_node("Sprite2D").texture.get_size() == Vector2(texture_size,texture_size),
	"The sprite of the tile should be of "+str(texture_size)+"x"+str(texture_size)+" dimension")

func next_left()->TileAbstract:
	assert(false,"This function should be considered abstract and must be overriden.")
	return null

func next_up()->TileAbstract:
	assert(false,"This function should be considered abstract and must be overriden.")
	return null
	
func next_right()->TileAbstract:
	assert(false,"This function should be considered abstract and must be overriden.")
	return null

func next_down()->TileAbstract:
	assert(false,"This function should be considered abstract and must be overriden.")
	return null
