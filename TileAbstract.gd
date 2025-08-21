class_name TileAbstract extends Node2D
## The abstract representation of a Tile, used to factorize code between different Tiles classes. As it is abstract, it shouldn't be instantiated on its own.


## The tile directly up of this one, if any.
var up:TileAbstract = null

## The tile directly down of this one, if any.
var down:TileAbstract = null

## The tile directly left of this one, if any.
var left:TileAbstract = null

## The tile directly right of this one, if any.
var right:TileAbstract = null

## The only authorized size for textures for sprites in the tile. If not respected, an error is thrown.
var texture_size:int = 128


func _to_string():
	return "TileAbstract"

## Throws an error if [member TileAbstract.texture_size] is not respected.
func verify_texture_size():
	assert(has_node("Sprite2D") and get_node("Sprite2D").texture.get_size() == Vector2(texture_size,texture_size),
	"The sprite of the tile should be of "+str(texture_size)+"x"+str(texture_size)+" dimension")

## Base function that should be overriden by all children of the class.
## This function is considered abstract and shouldn't be called.
func next_left()->TileAbstract:
	assert(false,"This function should be considered abstract and must be overriden.")
	return null

## Base function that should be overriden by all children of the class.
## This function is considered abstract and shouldn't be called.
func next_up()->TileAbstract:
	assert(false,"This function should be considered abstract and must be overriden.")
	return null
	
## Base function that should be overriden by all children of the class.
## This function is considered abstract and shouldn't be called.
func next_right()->TileAbstract:
	assert(false,"This function should be considered abstract and must be overriden.")
	return null

## Base function that should be overriden by all children of the class.
## This function is considered abstract and shouldn't be called.
func next_down()->TileAbstract:
	assert(false,"This function should be considered abstract and must be overriden.")
	return null
