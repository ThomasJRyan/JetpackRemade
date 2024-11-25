extends Sprite2D

func _on_collectable_body_entered(body: Node2D) -> void:
	if body is Player:
		body.lives += 1
