extends Label

@export var charater : CharacterBody2D

func _process(delta):
	text = "NextMove: " + str(charater.next_move)
