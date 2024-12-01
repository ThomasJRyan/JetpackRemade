@tool
extends Sprite2D
class_name ToggleBlock

@export var colour: Color
var dull_colour: Color

@onready var collision = $StaticBody2D/CollisionShape2D

var is_toggled := false

func _enter_tree() -> void:
	material.set_shader_parameter("colour", colour)
	
func _ready() -> void:
	dull_colour = colour - Color(0.7, 0.7, 0.7, 0.0)

func toggle_off() -> void:
	is_toggled = true
	#collision.disabled = true
	collision.set_deferred("disabled", true)
	material.set_shader_parameter("colour", dull_colour)
	
func toggle_on() -> void:
	is_toggled = false
	collision.disabled = false
	collision.set_deferred("disabled", false)
	material.set_shader_parameter("colour", colour)
	
func toggle() -> bool:
	if is_toggled:
		toggle_on()
	else:
		toggle_off()
	return is_toggled
