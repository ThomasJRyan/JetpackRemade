extends State

@export var moving_state : State
@export var climbing_velocity : int = 2

func _move(delta):
	if not character.current_path:
		return
		
	character.update_next_move()
		
	character.velocity.x = 0
	character.position.y += climbing_velocity * character.next_move.y
	#character.velocity.y = climbing_velocity * character.next_move.y * delta
	
	if character.next_move.y == 0:
		next_state = moving_state

func state_process(delta):
	if character.is_centered():
		character.update_path()
		
	_move(delta)	
	
	if not character.is_on_ladder():
		next_state = moving_state
		
	
func on_enter():
	character.sprite.play("Climb")
