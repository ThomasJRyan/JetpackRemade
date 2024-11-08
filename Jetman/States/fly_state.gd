extends State
class_name FlyState

@export var fly_vert_speed: int = 100
@export var maximum_thrust: int = -250
@export var fuel_consumption: int = 1
@export var fall_state: State

func enter(from: State) -> void:
	if from is IdleState:
		parent.animations.play("idle_fly")
	elif from is WalkState:
		parent.animations.play("walk_fly")
	
func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	parent.fuel -= fuel_consumption
	
	if parent.fuel == 0:
		return fall_state
	
	if !Input.is_action_pressed("jump"):
		return fall_state
		
	var movement = Input.get_axis('left', 'right') * move_speed
	if movement != 0:
		parent.direction = movement
		
	if movement == 0:
		parent.animations.play("idle_fly")
	else:
		parent.animations.play("walk_fly")
		
	parent.animations.flip_h = parent.direction < 0
	parent.velocity.y -= fly_vert_speed
	if parent.velocity.y < maximum_thrust:
		parent.velocity.y = maximum_thrust
	parent.velocity.x = movement
	parent.move_and_slide()
	return null
