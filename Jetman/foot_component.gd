extends Area2D
class_name FootComponent

@export var character: CharacterBody2D

var touching_something := 0
var default_speed: int

func _ready():
	default_speed = character.state_machine.current_state.move_speed

func modify_speed(value: float) -> void:
	if not touching_something:
		character.state_machine.current_state.move_speed *= value

func reset_speed() -> void:
	if not touching_something:
		character.state_machine.current_state.move_speed = default_speed
