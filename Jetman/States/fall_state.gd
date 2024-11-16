extends State
class_name FallState

@export_category("States")
@export var idle_state: IdleState
@export var walk_state: WalkState
@export var idle_fly_state: IdleFlyState
@export var walk_fly_state: WalkFlyState
@export var phase_state: State

@export_category("Raycasts")
@export var feet_raycast: FeetRayCast

	
func process_input(event: InputEvent) -> State:
	var direction = Input.get_axis("left", "right")
	parent.direction = direction
	
	if Input.is_action_just_pressed("jump") and parent.fuel > 0:
		if direction:
			return walk_fly_state
		return idle_fly_state
	if Input.is_action_just_pressed("phaser"):
		return phase_state
	return null

func process_physics(delta: float) -> State:
	if parent.velocity.y < terminal_velocity:
		parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("left", "right") * move_speed
	parent.direction = movement
		
	parent.animations.flip_h = parent.direction < 0
	parent.velocity.x = movement
	
	if feet_raycast.is_a_foot_colliding_with("Climbable"):
		if movement != 0:
			return walk_state
		return idle_state
		
	parent.move_and_slide()
	
	if parent.is_on_floor() and movement:
		return walk_state
	if parent.is_on_floor():
		return idle_state
	
	return null
