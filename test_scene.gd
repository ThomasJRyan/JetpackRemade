extends Node2D

func _ready() -> void:
	for collectable in get_tree().get_nodes_in_group("collectable"):
		collectable.connect("collected", _collect_treasure)
	
func _collect_treasure(points):
	print("Treasure collected " + str(points))
