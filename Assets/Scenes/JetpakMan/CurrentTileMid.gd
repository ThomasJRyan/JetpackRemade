extends Label

@export var character : CharacterBody2D

func _process(delta):
	var mid_tile_cords = character.tile_map.map_to_local(character.current_tile_cords)
	text = "CurrTileMid: " + str(mid_tile_cords)
