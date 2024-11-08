extends State
class_name FallState

@export var idle_state: State
@export var walk_state: State
@export var fly_state: State
@export var phase_state: State

func enter(from: State) -> void:
	super(from)
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.fuel > 0:
		return fly_state
	if Input.is_action_just_pressed("phaser"):
		return phase_state
	return null

func process_physics(delta: float) -> State:
	if parent.velocity.y < terminal_velocity:
		parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("left", "right") * move_speed
	if movement != 0:
		parent.direction = movement
		
	parent.animations.flip_h = parent.direction < 0
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.is_on_floor() and movement:
		return walk_state
	if parent.is_on_floor():
		return idle_state
	
	return null
