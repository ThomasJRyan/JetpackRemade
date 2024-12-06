extends State
class_name OrbFallState

@export var orb_move_state: OrbMoveState

func enter() -> void:
	parent.velocity.x = 0
	super()

func process_physics(delta: float) -> State:
	if parent.velocity.y < terminal_velocity:
		parent.velocity.y += gravity * delta
	
	if parent.is_on_floor():
		return orb_move_state
		
	parent.move_and_slide()
	
	return null
