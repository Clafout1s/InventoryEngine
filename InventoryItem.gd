class_name InventoryItem extends Node2D
## An exemple of what could be stored in tiles.


var possible_sprites:Array = [preload("res://images/chicken_leg.png"),preload("res://images/sword_tex.png")]
var active_sprite


func _ready():
	active_sprite = possible_sprites.pick_random()
	get_node("Sprite2D").texture = active_sprite

## Returns true if [param other] is an [InventoryItem] with the same sprite, false otherwise.
func equals(other:Node2D)->bool:
	if other is InventoryItem and other.active_sprite == self.active_sprite:
		return true
	return false
