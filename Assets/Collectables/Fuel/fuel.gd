extends Area2D

@export var fuel_amount: float = 1.0

@onready var fuel_node = $".."

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body is Player:
		body.fuel += body.max_fuel * fuel_amount
		fuel_node.queue_free()
