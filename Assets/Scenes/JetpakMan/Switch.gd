extends Label

@export var charater : JetpakMan

func _process(delta):
	text = "Switch: " + str(charater.switch_number)
