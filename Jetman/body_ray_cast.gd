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
