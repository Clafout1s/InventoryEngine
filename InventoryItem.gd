extends Node2D

var possible_sprites:Array = [preload("res://images/chicken_leg.png"),preload("res://images/sword_tex.png")]

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Sprite2D").texture = possible_sprites.pick_random()

