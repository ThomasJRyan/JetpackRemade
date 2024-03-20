extends Label

@export var character : CharacterBody2D

func _process(delta):
	text = "CurrTile: " + str(character.current_tile_cords)
