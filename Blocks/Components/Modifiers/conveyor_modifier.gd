extends Modifier
class_name ConveyorModifier

@export var reverse: bool

@onready var animation = $AnimatedSprite2D

func _ready() -> void:
	modifier_data = modifier_data.duplicate()
	if reverse:
		animation.flip_h = true
		modifier_data["x_movement"] *= -1
