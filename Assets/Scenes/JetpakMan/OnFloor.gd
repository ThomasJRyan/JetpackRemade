extends Label

@export var character : JetpakMan

func _process(delta):
	#text = "OnFloor: " + str(character.floor_raycast.is_colliding())
	text = "OnFloor: " + str(character.floor_raycast.is_colliding() and character.is_on_floor()) 
