extends State
class_name IdleFlyState

@export var fly_vert_speed: int = 100
@export var maximum_thrust: int = -250
@export var fuel_consumption: int = 1

@export var fall_state: FallState
@export var walk_fly_state: WalkFlyState

func process_input(event: InputEvent):
	if Input.get_axis('left', 'right'):
		return walk_fly_state

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	parent.fuel -= fuel_consumption
	
	if parent.fuel == 0:
		return fall_state
	
	if !Input.is_action_pressed("jump"):
		return fall_state
		
	var movement = Input.get_axis('left', 'right') * move_speed
	parent.direction = movement
		
	parent.animations.flip_h = parent.direction < 0
	parent.velocity.y -= fly_vert_speed
	if parent.velocity.y < maximum_thrust:
		parent.velocity.y = maximum_thrust
	parent.velocity.x = movement
	parent.move_and_slide()
	return null
