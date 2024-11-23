extends CharacterBody2D
class_name Player

signal fuel_changed(fuel)

@onready var state_machine = $StateMachine
@onready var animations = $AnimatedSprite2D

@export var max_fuel: float = 10000
@export var fuel: float = 10000:
	set(value):
		fuel = clamp(value, 0, max_fuel)
		emit_signal("fuel_changed", fuel)

var speed_modifier: float = 1.0

var direction = 1:
	set(value):
		if value > 0:
			direction = 1
		elif value < 0:
			direction = -1

func _ready() -> void:
	state_machine.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
