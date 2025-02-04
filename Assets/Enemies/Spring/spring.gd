extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var down_cast: RayCast2D = $RaycastDown
@onready var up_cast: RayCast2D = $RaycastUp

@export var speed: int = 50

var direction: bool = true

func _physics_process(delta: float) -> void:
	velocity.y = speed

	if down_cast.is_colliding() and direction:
		direction = false
		animation.play("CollideDown")
		await animation.animation_finished
		animation.play("Move")
		speed *= -1
		
	if up_cast.is_colliding() and not direction:
		direction = true
		animation.play("CollideUp")
		await animation.animation_finished
		animation.play("Move")
		speed *= -1
		
	move_and_slide()
