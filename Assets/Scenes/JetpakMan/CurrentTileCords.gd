extends Label

@export var character : JetpakMan

func _process(delta):
	text = "CurrTile: " + str(character.current_tile_cords)
