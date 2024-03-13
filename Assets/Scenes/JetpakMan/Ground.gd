extends State

@export var jump_velocity : int = -280
@export var slide_speed : float = 3
@export var push_speed : float = 1.5

@export var air_state : State
@export var climbing_state : State

@export var move_animation : String = "Move"
@export var idle_jump_animation : String = "JumpIdle"
@export var moving_jump_animation : String = "JumpMoving"
@export var climbing_animation: String = "Climb"

func on_enter():
	playback.travel(move_animation)

func state_process(delta):
	if character.is_on_ladder():
		character.velocity.y = 0
		
	if character.is_pushed_left():
		character.position.x -= push_speed
	if character.is_pushed_right():
		character.position.x += push_speed
	if character.is_pushed_up():
		character.position.y -= push_speed
	if character.is_pushed_down():
		character.position.y += push_speed
		
	if character.is_sliding():
		character.position.x += slide_speed * character.last_direction
		
	#if (Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down")) \
	#and character.is_on_ladder():
	##and character.is_middle_colliding():
	##and not character.is_on_floor():
		#climb()
		
	#if character.is_bottom_colliding() and character.is_on_ladder() and not character.is_middle_colliding():
		#character.skip_gravity_check = 1
		#character.position.y -= 1
		
		
	if Input.is_action_pressed("move_up") and character.is_on_ladder() and character.is_middle_colliding():
		climb()
	elif Input.is_action_pressed("move_down") and character.is_on_ladder() and not character.is_on_floor():
		climb()
	elif Input.is_action_pressed("move_down") and character.floor_raycast.is_colliding() and character.is_on_floor():
		character.set_collision_mask_value(4, false)
		climb()

func state_input(event: InputEvent):
	if event.is_action_pressed("thrust") and character.has_fuel():
		jump()
	elif event.is_action_pressed("thrust") and not character.ceiling_raycast.is_colliding():
		jump()
		
func jump():
	character.velocity.y = jump_velocity
	if character.fuel <= 0:
		if character.velocity.x == 0:
			playback.travel(idle_jump_animation)
		else:
			playback.travel(moving_jump_animation)
	next_state = air_state

func climb():
	playback.travel(climbing_animation)
	next_state = climbing_state
