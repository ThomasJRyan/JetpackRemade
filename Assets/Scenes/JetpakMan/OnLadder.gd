extends Label

@export var charater : JetpakMan

func _process(delta):
	text = "OnLadder: " + str(charater.on_ladder)
