extends Node2D
class_name BodyRayCast

@onready var body_cast: ShapeCast2D = $RayCast

func is_body_colliding() -> bool:
	return body_cast.is_colliding()

func is_body_colliding_with(name: String) -> bool:
	if body_cast.is_colliding():
		var collision_object = body_cast.get_collider(0)
		if collision_object is not Modifier:
			return false
		return body_cast.is_colliding() and collision_object.modifier_name == name
	return false
	
func is_body_colliding_with_any(names: Array[String]) -> bool:
	for name in names:
		if is_body_colliding_with(name):
			return true
	return false

func get_surface_data() -> Dictionary:
	if !body_cast.get_collision_count():
		return {}
	var collision_object = body_cast.get_collider(0)
	
	if collision_object is not Modifier:
		return {}
	if collision_object is Modifier:
		return collision_object.modifier_data
	
	return {}

func get_collider() -> CollisionObject2D:
	if body_cast.is_colliding():
		return body_cast.get_collider(0)
	return null
