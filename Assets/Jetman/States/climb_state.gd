extends State
class_name ClimbState

@export_category("States")
@export var idle_state: IdleState
@export var walk_state: WalkState

@export_category("Variables")
@export var climb_speed: int = 100

@export_category("Raycasts")
@export var body_raycast: BodyRayCast

func enter() -> void:
	super()
	parent.velocity.x = 0

func process_physics(delta: float) -> State:
	
	if Input.is_action_pressed("up"):
		if !body_raycast.is_body_colliding_with_any(CLIMBABLES):
			parent.velocity.y = 0
			return idle_state
		var data = body_raycast.get_surface_data()
		var y_movement = data.get("y_movement", 0)
		parent.velocity.y = -climb_speed + y_movement
		parent.move_and_slide()
		return null
	elif Input.is_action_pressed("down"):
		var data = body_raycast.get_surface_data()
		var y_movement = data.get("y_movement", 0)
		parent.velocity.y = climb_speed + y_movement
		parent.move_and_slide()
		return null
	
	var movement = Input.get_axis("left", "right")
	if movement != 0:
		return walk_state
	return idle_state
