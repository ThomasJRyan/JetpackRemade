extends Node
class_name Collectable

signal collected(points)

@export var points: int = 0
@export var remove_collectable: bool = true

@onready var collectable_node: Node2D = $".."


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("collected", points)
		if remove_collectable:
			collectable_node.queue_free()
