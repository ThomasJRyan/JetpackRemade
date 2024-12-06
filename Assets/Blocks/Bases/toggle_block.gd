@tool
extends Sprite2D
class_name ToggleBlock

@export_category("Variables")
@export var colour: Color
var dull_colour: Color

@onready var collision = $StaticBody2D/CollisionShape2D

var is_toggled := false

func _enter_tree() -> void:
	# Set the colour of the toggle block in the shader
	# Used for changing colour in the editor and during runtime
	material.set_shader_parameter("colour", colour)
	
func _ready() -> void:
	# Set a duller colour for when the block is toggled off
	dull_colour = colour - Color(0.7, 0.7, 0.7, 0.0)

func toggle_off() -> void:
	"""
	Toggles the block off, disabling the collision and changing the colour
	"""
	is_toggled = true
	# Need to use set_deferred to actually disable the collision
	collision.set_deferred("disabled", true)
	material.set_shader_parameter("colour", dull_colour)
	
func toggle_on() -> void:
	"""
	Toggles the block on, enabling the collision and changing the colour
	"""
	is_toggled = false
	collision.disabled = false
	collision.set_deferred("disabled", false)
	material.set_shader_parameter("colour", colour)
	
func toggle() -> bool:
	"""
	Toggles the block on or off depending on the current state

	Returns:
		bool: The state of the block after toggling
	"""
	if is_toggled:
		toggle_on()
	else:
		toggle_off()
	return is_toggled
