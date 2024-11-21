extends State
class_name WalkState

@export_category("States")
@export var idle_state: IdleState
@export var jump_state: WalkJumpState
@export var fly_state: WalkFlyState
@export var phase_state: PhaseState
@export var fall_state: FallState
@export var slide_state: SlideState
@export var climb_state: ClimbState

@export_category("Objects")
@export var foot_raycast: FeetRayCast
@export var body_raycast: BodyRayCast

@export_category("Variables")
@export_range(0.0, 1.0, 0.05) var grass_speed: float

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		if parent.fuel > 0:
			return fly_state
		return jump_state
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
		
	var movement = Input.get_axis("left", "right") * move_speed
	parent.direction = movement
	
	if movement == 0:
		return idle_state
		
	if !parent.is_on_floor() and !body_raycast.is_body_colliding_with_any(CLIMBABLES) and !foot_raycast.is_a_foot_colliding_with_any(CLIMBABLES):
		return fall_state
		
	parent.animations.flip_h = parent.direction < 0
	parent.velocity.x = movement * parent.speed_modifier
	
	if foot_raycast.is_a_foot_colliding():
		if foot_raycast.get_surface_name() == "Ice":
			return slide_state
		if foot_raycast.get_surface_name() == "Grass":
			parent.speed_modifier = grass_speed
			parent.move_and_slide()
			return null
		if foot_raycast.get_surface_name() == "Conveyor":
			var surface_data = foot_raycast.get_surface_data()
			var conveyor_movement = surface_data.get("x_movement")
			parent.velocity.x = movement + conveyor_movement
			parent.move_and_slide()
			return null
			
	parent.move_and_slide()
	
	parent.speed_modifier = 1.0	
	return null
