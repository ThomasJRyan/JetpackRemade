extends Label

@export var charater : JetpakMan

func _process(delta):
	text = "Sliding: " + str(charater.is_sliding())
