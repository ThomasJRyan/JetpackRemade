extends Area2D
class_name GrassModifer

@export_range(0, 1, 0.05) var grass_modifier = 0.60

@onready var grass_sprite = $Grass


func _on_body_entered(body: Player) -> void:
	body.speed_modifier = grass_modifier
	body.feet_touching += 1

func _on_body_exited(body: Player) -> void:
	body.feet_touching -= 1
	if body.feet_touching == 0:
		body.speed_modifier = 1
