extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.kill(body.DEATHS.BLOODY)
