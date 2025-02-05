extends CharacterBody2D
class_name OrbEnemy

@onready var state_machine: StateMachine = $StateMachine
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

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
