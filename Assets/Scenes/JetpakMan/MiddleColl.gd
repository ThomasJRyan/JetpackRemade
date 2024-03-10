extends Label

@export var character : JetpakMan

func _process(delta):
	text = "Middle: " + str(character.is_middle_colliding())
