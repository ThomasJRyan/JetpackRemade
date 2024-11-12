extends RayCast2D

@export var state_machine: StateMachine
@export var slide_state: SlideState

func _physics_process(delta: float) -> void:
	if is_colliding():
		if state_machine.current_state is not SlideState:
			state_machine.change_state(slide_state)
