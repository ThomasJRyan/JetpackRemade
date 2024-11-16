extends Modifier
class_name ClimbableModifier

#@onready var block_collision: CollisionShape2D = $"../CollisionShape2D"
#@onready var ray_cast: RayCast2D = $RayCast2D

#func _process(delta) -> void:
	#if ray_cast.is_colliding():
		#block_collision.disabled = true
