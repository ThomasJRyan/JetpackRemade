extends Label

@export var charater : JetpakMan

func _process(delta):
	text = "XSpeed: " + str(charater.velocity.x)
