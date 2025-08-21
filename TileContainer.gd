class_name TileContainer extends TileAbstract
## A Tile that contains items.

## If the tile is selected.
var selected:bool = false

## The array of items in the tile. [b] All items must be equals and must a equals function [/b], but can be stacked.
var content:Array

## The sprite texture of a selected [TileContainer].
var spriteSelected:CompressedTexture2D

## The sprite texture of an unselected [TileContainer].
var spriteNormal:CompressedTexture2D


func _to_string():
	return "TileContainer"

func _ready():
	super.verify_texture_size()

## This function is akin to a constructor, and will load the variables [member TileContainer.sprite_selected] and [member TileContainer.sprite_normal].
func load_sprites(sprite_normal:CompressedTexture2D,sprite_selected:CompressedTexture2D):
	self.spriteSelected = sprite_selected
	self.spriteNormal = sprite_normal
	unselect_tile()

## Select the tile and change its texture and opacity.
func select_tile():
	selected = true
	$Sprite2D.texture = spriteSelected
	modulate.a = 0.7

## Unselect the tile and change its texture and opacity.
func unselect_tile():
	selected = false
	modulate.a = 1
	$Sprite2D.texture = spriteNormal

## Add an item to [member TileContainer.content]. 
## The function makes sure than only identical items are stacked in the tile.
## [param item]: A scene displayed in the tile. [b] It must have an equals function ![/b]
func add_item(item:Node2D):
	assert(item.has_method("equals"),"The item instance must have an equals function !")
	if content == [] or (content != [] and content[0].equals(item)):
		content.push_back(item)
		add_to_display(1)
		if content.size() == 1:
			add_child(item)

## Remove one item from content.
## Returns the removed item scene.
func remove_item()->Node2D:
	var old_content = content.pop_back()
	substract_to_display(1)
	if content.size() == 0:
		remove_child(old_content)
	return old_content

## Returns the next Tile left, that is a [TileContainer].
func next_left()->TileAbstract:
	if left is TileAbstract and not left is TileContainer:
		return left.next_left()
	else:
		return left

## Returns the next Tile up, that is a [TileContainer].
func next_up()->TileAbstract:
	if up is TileAbstract and not up is TileContainer:
		return up.next_up()
	else:
		return up

## Returns the next Tile right, that is a [TileContainer].
func next_right()->TileAbstract:
	if right is TileAbstract and not right is TileContainer:
		return right.next_right()
	else:
		return right

## Returns the next Tile down, that is a [TileContainer].
func next_down()->TileAbstract:
	if down is TileAbstract and not down is TileContainer:
		return down.next_down()
	else:
		return down

## Returns the number of items indicated by the [Label] node.
func get_number_displayed()->int:
	return int($Label.text)

## Substract from the tile's [Label].
func substract_to_display(value:int):
	var new_num:int = get_number_displayed() - value
	$Label.text = String.num(new_num)
	if get_number_displayed() <= 1:
		$Label.visible = false
	else:
		$Label.visible = true

## Add to the tile's [Label].
func add_to_display(value:int):
	var new_num:int = get_number_displayed() + value
	$Label.text = String.num(new_num)
	if get_number_displayed() <= 1:
		$Label.visible = false
	else:
		$Label.visible = true
	
