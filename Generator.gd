
class_name Generator extends Node
## This class will generate a grid of tiles by the use of its main function [method generate_tile].


## The scene of a container tile.
var tile_container_scene:PackedScene = preload("res://TileContainer.tscn")

## The scene of a void tile.
var tile_void_scene:PackedScene = preload("res://TileVoid.tscn")

## Generate all the tiles by following a specific input string. [br]
## [param scene]: The scene in which the tiles will be created [br]
## [param input_str]: The string that indicates tile placement. 
## It forms a matrix where only [b]0[/b] (TileVoid), [b]X[/b] (TileContainer), [b]underscores[/b] (absence of tile)
## and [b]line breaks[/b] are considered. [br]
## [param margin]: The margin between tiles. [br]
## [param tile_size]: The maximum possible size of a tile. If it is too big to fit, the size will be
## automatically recalculated.
## Exemple of an the input_str: [br]
## [codeblock] "0 0 X 0 0    
##   0 X 0 _ _
##   0 0 X 0 0"   [/codeblock]
func generate_tiles(scene:Node2D,data:TileGenerationData)->Node2D:
	var manager = preload("res://TilesManager.tscn").instantiate()
	scene.add_child(manager)
	var input = clean_input_string(data.input_str)
	var list_tiles = [[]]
	var line = 0
	var column = 0
	var lines_str = Array(input.split("E"))
	var max_a:int=0
	for a in lines_str:
		if len(a) > max_a:
			max_a = len(a)
	var nb = Vector2(max_a,input.count("E")+1) #max number of tiles (column, line)
	var l = manager.get_viewport_rect().size.x #length of screen
	var h = manager.get_viewport_rect().size.y #height of screen
	var o = Vector2(l/2, h/2) # center of screen
	var s:float # size of the tiles (it's a square: only one dimension is stored)
	# resizing the tiles if they are too big
	if (data.tile_size + data.margin) * nb.x > l or (data.tile_size + data.margin) * nb.y > h:
		# in what dimension do the tiles take the most space
		if ((data.tile_size + data.margin) * nb.x - l) > ((data.tile_size + data.margin) * nb.y- h):
			#resizing based on columns
			s = (l/nb.x) - data.margin
		else:
			#resizing based on lines
			s = (h/nb.y) - data.margin
	else:
		# no resizing
		s = data.tile_size

	# Creating all the tiles, and adding them to the scene, 
	# without linking them together (stored in a temporary array)
	for letter in input:
		if letter == "E":
			# E is return to line
			list_tiles.append([])
			line+=1
			column = 0
		elif letter == "_":
			column+=1
			list_tiles[line].append(null)
		elif letter in ["X","0"]:
			# X is VoidTile, 0 is ContainerTile
			var p = Vector2(column,line) #coordinate of the tile in input
			var posi_tile = Vector2()
			posi_tile.x = o.x + (data.margin + s) * (p.x - floor(nb.x /2))
			posi_tile.y = o.y + (data.margin + s) * (p.y - floor(nb.y /2))
			#there is a slight difference if the number of tiles is even
			if int(nb.x) % 2 == 0:
				posi_tile.x += 1/2. * (data.margin+s)
			if int(nb.y) %2 == 0:
				posi_tile.y += 1/2. * (data.margin+s)
			var tile
			if letter == "X":
				tile = tile_void_scene.instantiate()
			elif letter == "0":
				tile = tile_container_scene.instantiate()

			manager.add_child(tile)
			tile.load_sprites(data.tile_sprite_normal,data.tile_sprite_selected)
			tile.position = posi_tile
			var actual_size = tile.texture_size
			# tile_container.get_node("Sprite2D").texture.get_size() -> to get texture size
			tile.scale = Vector2(s/float(actual_size),s/float(actual_size))
			list_tiles[line].append(tile)
			column+=1
		else:
			assert(false,"Wrong letter in input")
	
	# Creating the links between all tiles
	for newline in range(len(list_tiles)):
		for newcolumn in range(len(list_tiles[newline])):
			if list_tiles[newline][newcolumn] is TileAbstract:
				if newcolumn > 0:
					if list_tiles[newline][newcolumn - 1] is TileAbstract:
						list_tiles[newline][newcolumn].left = list_tiles[newline][newcolumn - 1]
				if newcolumn < len(list_tiles[newline]) - 1:
					if list_tiles[newline][newcolumn + 1] is TileAbstract:
						list_tiles[newline][newcolumn].right = list_tiles[newline][newcolumn + 1]
				if newline > 0 and len(list_tiles[newline - 1]) > newcolumn:
					if list_tiles[newline - 1][newcolumn] is TileAbstract:
						list_tiles[newline][newcolumn].up = list_tiles[newline - 1][newcolumn]
				if newline < len(list_tiles) - 1 and len(list_tiles[newline + 1]) > newcolumn:
					if list_tiles[newline + 1][newcolumn] is TileAbstract:
						list_tiles[newline][newcolumn].down = list_tiles[newline + 1][newcolumn]
	
	manager.constructor(scene,list_tiles,data)
	return manager

## Turns the [param input] string, a matrix of letters and line breaks, into a single string without any 
## unnecessary characters, that can be processed by the generate_tiles function. [br]
## The only character that matters are 0, X, underscores and line breaks (transformed into E).
func clean_input_string(input:String)->String:
	var output:String
	var allowed_chars = ["0","X","_"]
	for letter in input:
		if letter == "\n":
			output+="E"
		if letter in allowed_chars:
			output+=letter
	return output

