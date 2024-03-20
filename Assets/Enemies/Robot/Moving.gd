extends State

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var climbing_state : State
@export var speed : int = 150

func _move(delta):
	if not character.current_path:
		return
		
	character.update_next_move()
		
	if character.next_move.y != 0 and character.is_on_ladder() and character.is_x_centered():
		character.velocity.x = 0
		next_state = climbing_state
	else:
		character.velocity.x = speed * character.direction

func state_process(delta):
	if character.is_centered():
		character.update_path()
		
	if not character.is_on_floor() and not character.check_if_gravity_skipped():
		character.velocity.x = 0
		character.velocity.y += gravity * delta
		character.move_and_slide()
		return
	
	if not character.paused:
		_move(delta)
	else:
		character.velocity = Vector2.ZERO
	
	
func on_enter():
	character.update_path()
	character.update_next_move()
	character.direction = character.next_move.x
	if character.next_move.x == 0:
		next_state = climbing_state
		return
	character.sprite.play("Movement")
