extends State
class_name Air

@export var flying_velocity : int = -80
@export var ground_state : State
@export var idle_animation : String = "Idle"
@export var grounded_animation : String = "Move"

@export var idle_flying_animation : String = "FlyIdle"
@export var moving_flying_animation : String = "FlyMoving"

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

func fly(delta):
	character.velocity.y = flying_velocity
	character.fuel -= 0.1
