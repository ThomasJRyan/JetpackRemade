extends State
class_name SlideState

@export var slide_speed: int = 150

@export var idle_state: IdleState
@export var idle_jump_state: IdleJumpState
@export var walk_jump_state: WalkJumpState
@export var idle_fly_state: IdleFlyState
@export var walk_fly_state: WalkFlyState
@export var fall_state: FallState

@export var foot_raycast: FeetRayCast

func process_input(event: InputEvent) -> State:
	var direction = Input.get_axis("left", "right")
	parent.direction = direction
	
	if Input.is_action_just_pressed("jump"):
		if direction:
			if parent.fuel > 0:
				return walk_fly_state
			return walk_jump_state
		if parent.fuel > 0:
			return idle_fly_state
		return idle_jump_state
		
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	parent.animations.flip_h = parent.direction < 0
	parent.velocity.x = slide_speed * parent.direction
	parent.move_and_slide()
	
	if parent.is_on_floor() and not foot_raycast.is_a_foot_colliding_with("Ice"):
		return idle_state
	elif !parent.is_on_floor() and not foot_raycast.is_a_foot_colliding_with("Ice"):
		return fall_state
				
	
	return null
