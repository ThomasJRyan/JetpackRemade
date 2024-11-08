extends State
class_name SlideState

@export var slide_speed: int = 150

@export var idle_state: IdleState
@export var jump_state: JumpState
@export var fly_state: FlyState

var on_ice: int = 0

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		if parent.fuel > 0:
			return fly_state
		return jump_state
		
	var direction = Input.get_axis("left", "right")
	if direction:
		parent.direction = direction
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	parent.animations.flip_h = parent.direction < 0
	parent.velocity.x = slide_speed * parent.direction
	parent.move_and_slide()
	
	if not on_ice:
		return idle_state
	
	return null
