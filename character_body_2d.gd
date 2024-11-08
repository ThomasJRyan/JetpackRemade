extends CharacterBody2D
class_name Player

@onready var state_machine = $StateMachine
@onready var animations = $AnimatedSprite2D

@export var max_fuel: int = 10000
@export var fuel: int = 10000:
	set(value):
		fuel = clamp(value, 0, max_fuel)

var speed_modifier: float = 1.0
var feet_touching: int = 0

var direction = 1:
	set(value):
		if value > 0:
			direction = 1
		elif value < 0:
			direction = -1
		else:
			direction = 0

func _ready() -> void:
	state_machine.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
