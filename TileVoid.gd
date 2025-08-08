
class_name TileVoid extends TileAbstract

func _to_string():
	return "TileVoid"

func _ready():
	super.verify_texture_size()

func next_left()->TileAbstract:
	if left is TileVoid:
		return left.next_left()
	return left

func next_up()->TileAbstract:
	if up is TileVoid:
		return up.next_up()
	return up

func next_right()->TileAbstract:
	if right is TileVoid:
		return right.next_right()
	return right

func next_down()->TileAbstract:
	if down is TileVoid:
		return down.next_down()
	return down
