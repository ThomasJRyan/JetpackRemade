extends State
class_name JumpState

@export var idle_state: State
@export var walk_state: State
@export var jump_speed: int = 200
@export var movement_penalty: float = 0.2

var idle_jump: bool

func enter(from: State) -> void: 
	if from is IdleState:
		parent.animations.play("idle_jump")
		idle_jump = true
	elif from is WalkState:
		parent.animations.play("walk_jump")
		idle_jump = false
	parent.velocity.y -= jump_speed

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement: float
	if idle_jump:
		movement = Input.get_axis('left', 'right') * move_speed * movement_penalty
	else:
		movement = Input.get_axis('left', 'right') * move_speed
	
	if movement != 0:
		parent.animations.flip_h = movement < 0
		parent.velocity.x = movement
		
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return walk_state
		return idle_state
	
	return null
