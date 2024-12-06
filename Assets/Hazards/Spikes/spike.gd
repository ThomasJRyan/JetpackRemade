extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	# Check if the body is a player
	# Then kill the player
	if body is Player:
		body.kill(body.DEATHS.BLOODY)
