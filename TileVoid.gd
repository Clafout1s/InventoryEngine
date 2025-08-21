class_name TileVoid extends TileAbstract
## A Tile that cannot contain items.


func _to_string():
	return "TileVoid"

func _ready():
	super.verify_texture_size()
	$Sprite2D.visible = false

## Returns the next Tile left, that isn't a [TileVoid].
func next_left()->TileAbstract:
	if left is TileVoid:
		return left.next_left()
	return left

## Returns the next Tile up, that isn't a [TileVoid]. 
func next_up()->TileAbstract:
	if up is TileVoid:
		return up.next_up()
	return up
	
## Returns the next Tile right, that isn't a [TileVoid].
func next_right()->TileAbstract:
	if right is TileVoid:
		return right.next_right()
	return right

## Returns the next Tile down, that isn't a [TileVoid].
func next_down()->TileAbstract:
	if down is TileVoid:
		return down.next_down()
	return down
