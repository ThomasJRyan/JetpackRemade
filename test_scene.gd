extends Node2D

@onready var slider = $Control/HSlider

func _ready() -> void:
	Engine.time_scale = slider.value
	for collectable in get_tree().get_nodes_in_group("collectable"):
		collectable.connect("collected", _collect_treasure)
	
func _collect_treasure(points):
	#print("Treasure collected " + str(points))
	pass


func _on_h_slider_value_changed(value: float) -> void:
	Engine.time_scale = value
