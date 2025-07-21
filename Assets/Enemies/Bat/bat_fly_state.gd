extends State
class_name BatFlyState

@export_category("States")
@export var fall_state: BatFallState

@export_category("Raycasts")
@export var top_cast: ShapeCast2D
@export var side_cast: ShapeCast2D
@export var bottom_cast: ShapeCast2D

@export_category("Movement")
@export var x_move_speed: int = 20
@export var y_move_speed: int = 30

var direction: Vector2i
var grounded: bool = false

func enter() -> void:
	super()
	grounded = true
	direction = parent.get_player_direction()
	
func process_physics(delta: float) -> State:
	parent.velocity.x = direction.x * x_move_speed * (0.75 if top_cast.is_colliding() else 1)
	
	if grounded and not bottom_cast.is_colliding():
		parent.velocity.y = -y_move_speed
		grounded = false
	
	if parent.get_player_direction_y() == -1:
		parent.velocity.y = -y_move_speed
		grounded = false
		
	if parent.get_player_direction_y() == 1:
		if not grounded:
			return fall_state
		else:
			parent.velocity.y = y_move_speed
		
	#
	##if parent.get_player_direction_x() == -direction.x and not top_cast.is_colliding():
		##return fall_state
		#
	if top_cast.is_colliding() and side_cast.is_colliding() and parent.get_player_direction_y() == -1:
		return fall_state
		
	if side_cast.is_colliding() and parent.get_player_direction_y() == -1:
		direction.x = parent.get_player_direction_x()
		#
	#if top_cast.is_colliding() and side_cast.is_colliding() and parent.get_player_direction_y() == 1:
		#if direction == parent.get_player_direction():
			##return fall_state
			#direction.x = -direction.x
		#direction = parent.get_player_direction()
	
	parent.move_and_slide()
	
	return null
