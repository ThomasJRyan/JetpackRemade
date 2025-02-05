extends State
class_name OrbMoveState

@export var orb_fall_state: OrbFallState

@onready var left_ray: RayCast2D = $"../../CollisionLeft"
@onready var right_ray: RayCast2D = $"../../CollisionRight"

func process_physics(delta: float) -> State:
	if !parent.is_on_floor():
		return orb_fall_state
	
	if left_ray.is_colliding():
		parent.direction = 1
	elif right_ray.is_colliding():
		parent.direction = -1
		
	parent.velocity.x = move_speed * parent.direction
	
	# TODO: Need to handle conveyors, grass, ladders, and teleporters
	
	parent.move_and_slide()
	
	return null
