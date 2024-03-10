extends State

@export var climbing_velocity : float = 1
@export var ground_state : State

func state_process(delta):
	if character.is_on_floor() and Input.is_action_pressed("move_down"):
		next_state = ground_state
		return
	
	if not character.is_on_ladder() and not Input.is_action_pressed("move_down"):
		next_state = ground_state
		return
	
	if Input.is_action_pressed("move_up"):
		climb_up(delta)
	elif Input.is_action_pressed("move_down"):
		climb_down(delta)
	elif Input.is_action_just_pressed("move_left"):
		next_state = ground_state
	elif Input.is_action_just_pressed("move_left"):
		next_state = ground_state
	else:
		character.velocity.y = 0

func state_input(event):
	if event.is_action_released("move_up"):
		animation_player.pause()
	elif event.is_action_released("move_down"):
		animation_player.pause()

func climb_up(delta):
	pull_towards_middle()
	character.position.y -= 1.5

func climb_down(delta):
	pull_towards_middle()
	character.position.y += 1.5
	
func get_tile_middle():
	return character.tile_map.map_to_local(character.current_tile_cords).x
	
func pull_towards_middle():
	if Input.get_axis("move_left", "move_right") != 0:
		return
	var tile_data = character.tile_map.get_cell_tile_data(0, character.current_tile_cords)
	if not tile_data:
		return
	var special_interaction: int = tile_data.get_custom_data("special_interaction")
	if special_interaction not in [1,2,3]:
		return
	var middle_of_tile = get_tile_middle()
	
	if character.position.x > middle_of_tile:
		character.position.x -= 1
	elif character.position.x < middle_of_tile:
		character.position.x += 1
