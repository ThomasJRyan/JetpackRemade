extends State
class_name Air

@export var flying_velocity : int = -80
@export var ground_state : State
@export var idle_animation : String = "Idle"
@export var grounded_animation : String = "Move"
@export var climbing_state : State

@export var idle_flying_animation : String = "FlyIdle"
@export var moving_flying_animation : String = "FlyMoving"
@export var climbing_animation: String = "Climb"

func state_process(delta):
	if character.is_on_floor():
		next_state = ground_state
		playback.travel(grounded_animation)
		return
	
	if Input.is_action_pressed("thrust"):
		if character.has_fuel():
			if character.velocity.x == 0:
				playback.travel(idle_flying_animation)
			else:
				playback.travel(moving_flying_animation)
			fly(delta)
	else:
		playback.travel(idle_animation)
		
	if not Input.is_action_pressed("thrust"):
		if Input.is_action_pressed("move_up") and character.is_on_ladder() and character.is_middle_colliding():
			climb()
		elif Input.is_action_pressed("move_down") and character.is_on_ladder() and not character.is_on_floor():
			climb()

func fly(delta):
	character.velocity.y = flying_velocity
	character.fuel -= 0.1

func climb():
	playback.travel(climbing_animation)
	next_state = climbing_state
