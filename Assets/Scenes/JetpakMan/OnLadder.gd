extends Label

@export var charater : CharacterBody2D

func _process(delta):
	text = "OnLadder: " + str(charater.on_ladder)
