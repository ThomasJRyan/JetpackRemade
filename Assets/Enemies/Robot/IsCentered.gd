extends Label

@export var character : CharacterBody2D

func _process(delta):
	text = "Centered: " + str(character.is_x_centered()) + " " + str(character.is_y_centered())
