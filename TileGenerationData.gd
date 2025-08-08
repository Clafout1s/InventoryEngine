class_name TileGenerationData extends Node

var input_str:String
var margin:int
var tile_size:int
var tile_sprite_normal:CompressedTexture2D
var tile_sprite_selected:CompressedTexture2D

func _init(str:String,margin:int,tile_size:int,sprite_normal:CompressedTexture2D,sprite_selected:CompressedTexture2D):
	self.input_str = str
	self.margin = margin
	self.tile_size = tile_size
	self.tile_sprite_normal = sprite_normal
	self.tile_sprite_selected = sprite_selected
