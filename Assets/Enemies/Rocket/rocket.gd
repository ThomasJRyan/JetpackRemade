extends CharacterBody2D
class_name RocketEnemy

@export var move_speed: int = 50

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var left_ray: RayCast2D = $LeftRay
@onready var right_ray: RayCast2D = $RightRay

var direction := Vector2(0, -1)

func _physics_process(delta: float) -> void:
	velocity = move_speed * direction
	
	if move_and_collide(velocity * delta):
		var deg_to_rotate = 90.0
		if left_ray.is_colliding():
			deg_to_rotate += 0
		if right_ray.is_colliding():
			deg_to_rotate -= 180.0
		rotate(deg_to_rad(deg_to_rotate))
		direction = direction.rotated(deg_to_rad(deg_to_rotate))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.kill()
