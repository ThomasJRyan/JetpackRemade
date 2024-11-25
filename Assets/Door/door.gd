extends AnimatedSprite2D
class_name Door

@onready var collision = $Area2D/CollisionShape2D

func open() -> void:
	play("default")
	await animation_finished
	collision.disabled = false
	
func close() -> void:
	collision.disabled = true
	play("default", -1.0, true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.dance()
