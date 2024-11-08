extends Area2D
class_name IceModifier

@export var ice_speed: int = 100

@onready var ice_sprite = $Ice

func _on_body_entered(body: Player) -> void:
	body.on_ice += 1
	var slide_state: State
	for child in body.state_machine.get_children():
		if child is SlideState:
			slide_state = child
			break
	body.state_machine.change_state(slide_state)

func _on_body_exited(body: Player) -> void:
	body.on_ice -= 1
