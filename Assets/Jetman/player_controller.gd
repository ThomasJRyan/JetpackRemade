extends CharacterBody2D
class_name Player

signal fuel_changed(fuel)
signal lives_changed(lives)

@onready var state_machine = $StateMachine
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

@export var max_fuel: float = 10000
@export var fuel: float = 10000:
	set(value):
		fuel = clamp(value, 0, max_fuel)
		emit_signal("fuel_changed", fuel)
		
@export var lives: int = 3:
	set(value):
		lives = clamp(value, 0, 99)
		emit_signal("lives_changed", lives)
		
enum DEATHS {
	BLOODY,
	EXPLOSIVE,
	VAPORIZED,
	GASSED,
}

var death_by: DEATHS

var speed_modifier: float = 1.0

var direction = 1:
	set(value):
		if value > 0:
			direction = 1
		elif value < 0:
			direction = -1
			
func kill(death_type: DEATHS = DEATHS.BLOODY) -> void:
	death_by = death_type
	state_machine.change_state($StateMachine/DeathState)

func dance():
	state_machine.change_state($StateMachine/DanceState)

func _ready() -> void:
	state_machine.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
