extends State
class_name WalkJumpState

@export_category("States")
@export var idle_state: IdleState
@export var walk_state: WalkState
@export var jump_speed: int = 200
@export var movement_penalty: float = 0.2

@export var feet_raycast: FeetRayCast

func enter() -> void: 
	super()
	parent.velocity.y -= jump_speed

func process_physics(delta: float) -> State:
	if parent.velocity.y < terminal_velocity:
		parent.velocity.y += gravity * delta
	
	var movement: float
	movement = Input.get_axis('left', 'right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
		parent.velocity.x = movement
		
	parent.move_and_slide()
	
	if feet_raycast.is_a_foot_colliding_with("Climbable") and parent.velocity.y > 0:
		if movement != 0:
			return walk_state
		return idle_state
	
	if parent.is_on_floor():
		if movement != 0:
			return walk_state
		return idle_state
	
	return null
