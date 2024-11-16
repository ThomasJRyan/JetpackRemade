extends Node2D
class_name FeetRayCast

@export var character: Player

@export var state_machine: StateMachine
@export var slide_state: SlideState

@onready var left_foot = $FootRayCastLeft
@onready var right_foot = $FootRayCastRight

func are_feet_colliding() -> bool:
	return left_foot.is_colliding() and right_foot.is_colliding()
	
func are_feet_colliding_with(name: String) -> bool:
	return (left_foot.is_colliding() and get_surface_name() == name) and (right_foot.is_colliding() and get_surface_name() == name)
	
func is_a_foot_colliding() -> bool:
	return left_foot.is_colliding() or right_foot.is_colliding()
	
func is_a_foot_colliding_with(name: String) -> bool:
	return (left_foot.is_colliding() and get_surface_name() == name) or (right_foot.is_colliding() and get_surface_name() == name)
	
func disable_feet() -> void:
	left_foot.enabled = false
	right_foot.enabled = false
	
func enable_feet() -> void:
	left_foot.enabled = true
	right_foot.enabled = true

func get_surface_name() -> String:
	var collision_object_left = left_foot.get_collider()
	var collision_object_right = right_foot.get_collider()
	
	if collision_object_left is not Modifier and collision_object_right is not Modifier:
		return "N/A"
	if collision_object_left is Modifier and collision_object_right is not Modifier:
		return collision_object_left.modifier_name
	if collision_object_left is not Modifier and collision_object_right is Modifier:
		return collision_object_right.modifier_name
	if collision_object_left is Modifier and collision_object_right is Modifier:
		var l_name = collision_object_left.modifier_name
		var r_name = collision_object_right.modifier_name
		if l_name == r_name:
			return l_name
		if character.direction == 1:
			return r_name
		if character.direction == -1:
			return l_name
		
	return "N/A"

func get_surface_data() -> Dictionary:
	var collision_object_left = left_foot.get_collider()
	var collision_object_right = right_foot.get_collider()
	
	if collision_object_left is not Modifier and collision_object_right is not Modifier:
		return {}
	if collision_object_left is Modifier and collision_object_right is not Modifier:
		return collision_object_left.modifier_data
	if collision_object_left is not Modifier and collision_object_right is Modifier:
		return collision_object_right.modifier_data
	if collision_object_left is Modifier and collision_object_right is Modifier:
		var l_data = collision_object_left.modifier_data
		var r_data = collision_object_right.modifier_data
		if l_data == r_data:
			return l_data
		if character.direction == 1:
			return r_data
		if character.direction == -1:
			return l_data
	
	return {}
