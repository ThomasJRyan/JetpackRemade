extends State
class_name IdleState

@export_category("States")
@export var walk_state: WalkState
@export var jump_state: IdleJumpState
@export var fly_state: IdleFlyState
@export var phase_state: PhaseState
@export var slide_state: SlideState
@export var climb_state: ClimbState

@export_category("Rays")
@export var foot_raycast: FeetRayCast
@export var body_raycast: BodyRayCast

func enter() -> void:
	super()
	parent.velocity.x = 0
	parent.velocity.y = 0
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		if parent.fuel > 0:
			return fly_state
		return jump_state
	if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		return walk_state
	if Input.is_action_just_pressed("phaser"):
		return phase_state
	if Input.is_action_just_pressed("up") and body_raycast.is_body_colliding_with_any(CLIMBABLES):
		return climb_state
	if Input.is_action_just_pressed("down") and foot_raycast.is_a_foot_colliding_with_any(CLIMBABLES):
		return climb_state
	return null
	
func process_physics(delta: float) -> State:
	if foot_raycast.is_a_foot_colliding_with("Climbable"):
		parent.velocity.y = 0
	elif foot_raycast.is_a_foot_colliding_with("MovingClimbable"):
		if Input.is_action_pressed("up") or !body_raycast.is_body_colliding_with("MovingClimbable"):
			parent.velocity.y = 0
		else:
			var surface_data = foot_raycast.get_surface_data()
			var climbable_movement = surface_data.get("y_movement")
			parent.velocity.y = climbable_movement
	else:
		parent.velocity.y += gravity * delta
			
	parent.move_and_slide()
	
	if foot_raycast.is_a_foot_colliding():
		if foot_raycast.get_surface_name() == "Ice":
			return slide_state
		if foot_raycast.get_surface_name() == "Conveyor":
			var surface_data = foot_raycast.get_surface_data()
			var conveyor_movement = surface_data.get("x_movement")
			parent.velocity.x = conveyor_movement
			return null
	
	parent.velocity.x = 0
	return null
