extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		region_rect.position.x = 13
		body.kill(body.DEATHS.BLOODY)
