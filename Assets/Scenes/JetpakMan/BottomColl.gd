extends Label

@export var character : JetpakMan

func _process(delta):
	text = "Bottom: " + str(character.is_bottom_colliding())
