extends CharacterBody2D
class_name StarEnemy

@export var move_speed: int = 50

@onready var left_cast: RayCast2D = $RayCasts/LeftCast
@onready var right_cast: RayCast2D = $RayCasts/RightCast
@onready var top_cast: RayCast2D = $RayCasts/TopCast
@onready var bottom_cast: RayCast2D = $RayCasts/BottomCast

var direction := Vector2.ZERO

func _ready() -> void:
	direction.x = [1,-1].pick_random()
	direction.y = [1,-1].pick_random()
	position = position + (Vector2(2, 2) * direction)
	direction.x *= -1
	
func _physics_process(delta: float) -> void:
	if left_cast.is_colliding():
		direction.x = 1
	elif right_cast.is_colliding():
		direction.x = -1
	elif top_cast.is_colliding():
		direction.y = 1
	elif bottom_cast.is_colliding():
		direction.y = -1
		
	velocity = move_speed * direction
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.kill()
