extends Sprite2D

signal gem_collected

@onready var collectable = $Collectable


func _on_collectable_collected(points: Variant) -> void:
	region_rect.position.x += 13
	collectable.queue_free()
	emit_signal("gem_collected")
