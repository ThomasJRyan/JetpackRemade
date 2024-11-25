extends StaticBody2D

@export var fuel_amount: int = 10

@onready var shape_cast = $ShapeCast2D

func _physics_process(delta: float) -> void:
	if shape_cast.is_colliding():
		var player: Player = shape_cast.get_collider(0)
		player.fuel += fuel_amount
