extends State
class_name WalkState

@export var idle_state: State
@export var jump_state: State
@export var fly_state: State
@export var phase_state: State
@export var fall_state: State

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		if parent.fuel > 0:
			return fly_state
		return jump_state
	if Input.is_action_just_pressed("phaser"):
		return phase_state
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("left", "right") * move_speed
	if movement != 0:
		parent.direction = movement
	
	if movement == 0:
		return idle_state
		
	if !parent.is_on_floor():
		return fall_state
		
	parent.animations.flip_h = parent.direction < 0
	parent.velocity.x = movement * parent.speed_modifier
	parent.move_and_slide()
	
	return null
