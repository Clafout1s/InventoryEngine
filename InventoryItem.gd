class_name InventoryItem extends Node2D

var possible_sprites:Array = [preload("res://images/chicken_leg.png"),preload("res://images/sword_tex.png")]
var active_sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	active_sprite = possible_sprites.pick_random()
	get_node("Sprite2D").texture = active_sprite

func equals(other:Node2D)->bool:
	if other is InventoryItem and other.get_node("Sprite2D").texture == self.get_node("Sprite2D").texture:
		return true
	return false
