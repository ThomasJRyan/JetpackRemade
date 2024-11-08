extends State
class_name IdleState

@export var walk_state: State
@export var jump_state: State
@export var fly_state: State
@export var phase_state: State

func enter(from: State) -> void:
	super(null)
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
	return null
