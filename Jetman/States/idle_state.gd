extends State
class_name IdleState

@export var walk_state: WalkState
@export var jump_state: IdleJumpState
@export var fly_state: IdleFlyState
@export var phase_state: PhaseState
@export var slide_state: SlideState

@export var foot_raycast: FeetRayCast

func enter() -> void:
	super()
	parent.velocity.x = 0
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		if parent.fuel > 0:
			return fly_state
		return jump_state
	if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
		return walk_state
	if Input.is_action_just_pressed("phaser"):
		return phase_state
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	parent.move_and_slide()
	
	if foot_raycast.is_a_foot_colliding():
		#print(foot_raycast.get_surface_data())
		if foot_raycast.get_surface_name() == "Ice":
			return slide_state
		if foot_raycast.get_surface_name() == "Conveyor":
			var surface_data = foot_raycast.get_surface_data()
			var conveyor_movement = surface_data.get("x_movement")
			parent.velocity.x = conveyor_movement
			return null
	
	parent.velocity.x = 0
	return null
