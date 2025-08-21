
class_name TileContainer extends TileAbstract

var selected:bool = false
var mouse_controls:bool = false
var content:Array
var spriteSelected:CompressedTexture2D
var spriteNormal:CompressedTexture2D
func _to_string():
	return "TileContainer"

func _init():
	pass

func _ready():
	super.verify_texture_size()

func load_sprites(sprite_normal:CompressedTexture2D,sprite_selected:CompressedTexture2D):
	self.spriteSelected = sprite_selected
	self.spriteNormal = sprite_normal
	unselect_tile()

func _on_area_2d_mouse_entered():
	if(mouse_controls):
		select_tile()

func _on_area_2d_mouse_exited():
	if mouse_controls:
		unselect_tile()

func select_tile():
	selected = true
	$Sprite2D.texture = spriteSelected
	modulate.a = 0.7

func unselect_tile():
	selected = false
	modulate.a = 1
	$Sprite2D.texture = spriteNormal

func add_item(item:Node2D):
	assert(item.has_method("equals"))
	content.push_back(item)
	add_to_display(1)
	if content.size() == 1:
		add_child(item)

func remove_item()->Node2D:
	var old_content = content.pop_back()
	substract_to_display(1)
	if content.size() == 0:
		remove_child(old_content)
	return old_content

func next_left()->TileAbstract:
	if left is TileAbstract and not left is TileContainer:
		return left.next_left()
	else:
		return left

func next_up()->TileAbstract:
	if up is TileAbstract and not up is TileContainer:
		return up.next_up()
	else:
		return up
	
func next_right()->TileAbstract:
	if right is TileAbstract and not right is TileContainer:
		return right.next_right()
	else:
		return right

func next_down()->TileAbstract:
	if down is TileAbstract and not down is TileContainer:
		return down.next_down()
	else:
		return down
	
func get_number_displayed()->int:
	return int($Label.text)

func substract_to_display(value:int):
	var new_num:int = get_number_displayed() - value
	$Label.text = String.num(new_num)
	if get_number_displayed() <= 1:
		$Label.visible = false
	else:
		$Label.visible = true

func add_to_display(value:int):
	var new_num:int = get_number_displayed() + value
	$Label.text = String.num(new_num)
	if get_number_displayed() <= 1:
		$Label.visible = false
	else:
		$Label.visible = true
	
