extends Label

@export var character : CharacterBody2D

func _process(delta):
	text = "NextTile: " + str(character.next_tile)
