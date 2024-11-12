extends State
class_name WalkJumpState

@export var idle_state: IdleState
@export var walk_state: WalkState
@export var jump_speed: int = 200
@export var movement_penalty: float = 0.2

func enter() -> void: 
	super()
	parent.velocity.y -= jump_speed

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement: float
	movement = Input.get_axis('left', 'right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
		parent.velocity.x = movement
		
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return walk_state
		return idle_state
	
	return null
