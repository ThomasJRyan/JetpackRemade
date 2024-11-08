@tool
extends Node2D

@export_enum("None", "Grass", "Ice", "Left Conveyor", "Right Conveyor") var movement_modifier = "None"
@export_flags("Left", "Right", "Top", "Bottom") var unbreakable_modifier = 0

@export_range(0, 1, 0.05) var grass_modifier = 0.75

@onready var grass_sprite = $Grass
@onready var ice_sprite = $Ice
@onready var conveyor_sprite = $Conveyor

func _process(delta: float) -> void:
	match movement_modifier:
		"None":
			grass_sprite.visible = false
			ice_sprite.visible = false
			conveyor_sprite.visible = false
		"Grass":
			grass_sprite.visible = true
			ice_sprite.visible = false
			conveyor_sprite.visible = false
		"Ice":
			grass_sprite.visible = false
			ice_sprite.visible = true
			conveyor_sprite.visible = false
		"Left Conveyor":
			grass_sprite.visible = false
			ice_sprite.visible = false
			conveyor_sprite.visible = true
			conveyor_sprite.flip_h = true
		"Right Conveyor":
			grass_sprite.visible = false
			ice_sprite.visible = false
			conveyor_sprite.visible = true
			conveyor_sprite.flip_h = false


func _on_area_2d_area_entered(foot: FootComponent) -> void:
	foot.modify_speed(grass_modifier)
