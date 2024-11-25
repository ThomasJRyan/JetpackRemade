extends StaticBody2D

@onready var sprite = $Sprite2D

func _on_breakable_component_breaking_block() -> void:
	sprite.queue_free()
