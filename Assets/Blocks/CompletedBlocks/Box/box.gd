extends StaticBody2D

@export_category("Nodes")
@onready var sprite = $Sprite2D

func _on_breakable_component_breaking_block() -> void:
	# Boxes are unique in that they don't come back after breaking
	sprite.queue_free()
