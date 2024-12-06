extends StaticBody2D

@export_category("Variables")
@export var fuel_amount: int = 10

@export_category("Nodes")
@onready var shape_cast = $ShapeCast2D

func _physics_process(_delta: float) -> void:
	# Get the collider from the shape cast, and if it's a player, add fuel
	if shape_cast.is_colliding():
		var player: Player = shape_cast.get_collider(0)
		if player is Player:
			player.fuel += fuel_amount
