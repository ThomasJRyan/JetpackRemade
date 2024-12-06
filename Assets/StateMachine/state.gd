extends Node
class_name State

@export var animation_name: String
@export var move_speed: float = 50
@export var terminal_velocity: int = 80

var active := false

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var parent: CharacterBody2D

# TODO: This should possibly be moved to a global set of variables, or I should
# be using signal groups to define what is climbable
var CLIMBABLES: Array[String] = ["Climbable", "MovingClimbable"]

func enter() -> void:
	parent.animations.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
