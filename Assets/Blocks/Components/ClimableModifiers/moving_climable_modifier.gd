extends Modifier
class_name MovingClimbableModifier

@export var reverse: bool

@export var animation: AnimatedSprite2D

func _ready() -> void:
	modifier_data = modifier_data.duplicate()
	if reverse:
		animation.flip_v = true
		modifier_data["y_movement"] *= -1
