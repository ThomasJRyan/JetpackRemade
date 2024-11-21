@tool
extends Modifier
class_name ConveyorModifier

@onready var animation = $AnimatedSprite2D

func _ready() -> void:
	modifier_data = modifier_data.duplicate()
	if modifier_data.get("reverse", false):
		animation.flip_h = true
		modifier_data["x_movement"] *= -1
