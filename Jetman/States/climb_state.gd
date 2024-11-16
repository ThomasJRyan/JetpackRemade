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
		if !body_raycast.is_body_colliding_with("Climbable"):
			parent.velocity.y = 0
			return idle_state
		parent.velocity.y = -climb_speed
		parent.move_and_slide()
		return null
	elif Input.is_action_pressed("down"):
		
		parent.velocity.y = climb_speed
		parent.move_and_slide()
		return null
	
	var movement = Input.get_axis("left", "right")
	if movement != 0:
		return walk_state
	return idle_state
