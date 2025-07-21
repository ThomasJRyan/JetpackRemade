extends State
class_name BatFallState

@export_category("States")
@export var fly_state: BatFlyState

@export_category("Raycasts")
@export var top_cast: ShapeCast2D
@export var side_cast: ShapeCast2D
@export var bottom_cast: ShapeCast2D

var direction: Vector2i
var init: bool = false

func enter() -> void:
	super()
	direction = parent.get_player_direction()

func process_physics(delta: float) -> State:
	if direction.y == -1 and not init:
		init = true
		return fly_state
	
	if parent.velocity.y < terminal_velocity:
		parent.velocity.y += gravity * delta
		
	if bottom_cast.is_colliding():
		return fly_state
		
	parent.velocity.x = direction.x * move_speed
	
	parent.move_and_slide()
	
	#if parent.get_player_direction_y() == -1:
		#if body_cast.is_colliding():
			#return null
		#return fly_state
	
	return null
