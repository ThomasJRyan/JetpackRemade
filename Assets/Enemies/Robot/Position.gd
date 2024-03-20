extends Label

@export var charater : CharacterBody2D

func _process(delta):
	text = "Position: " + str(charater.position)
