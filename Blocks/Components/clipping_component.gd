@tool
extends Sprite2D
class_name ClippingComponent

@export_flags("top_left", "top_right", "bottom_left", "bottom_right") var clipping_mask = 0

func _enter_tree() -> void:
	set_region_rect(Rect2(12 * clipping_mask, 0, 12, 12))
