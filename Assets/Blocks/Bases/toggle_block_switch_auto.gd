@tool
extends Sprite2D
class_name ToggleBlockSwitchAuto

@export var colour: Color

@onready var collision = $ShapeCast2D

var toggle_blocks: Array
var toggle_switches: Array
var is_toggled: bool

func _enter_tree() -> void:
	# Set the colour of the toggle block switch auto in the shader
	# Used for changing colour in the editor and during runtime
	material.set_shader_parameter("colour", colour)
	
func _ready() -> void:
	# Go through all the toggle blocks and toggle switches in the scene
	# and add them to the respective arrays. This is so we can toggle
	# them all at once when this switch is toggled
	for toggle_block in get_tree().get_nodes_in_group("toggle_block"):
		if toggle_block.colour == colour:
			toggle_blocks.append(toggle_block)
	for toggle_switch in get_tree().get_nodes_in_group("toggle_switch"):
		if toggle_switch.colour == colour:
			toggle_switches.append(toggle_switch)

func toggle_on() -> void:
	"""
	Toggles the switch on
	"""
	is_toggled = false
	
func toggle_off() -> void:
	"""
	Toggles the switch off
	"""
	is_toggled = true
	
func toggle() -> bool:
	"""
	Toggles the switch

	Returns:
		bool: The state of the switch
	"""

	# Toggles all the toggle blocks and toggle switches
	if is_toggled:
		for toggle_switch in toggle_switches:
			toggle_switch.toggle_on()
		for toggle_block in toggle_blocks:
			toggle_block.toggle_on()
	else:
		for toggle_switch in toggle_switches:
			toggle_switch.toggle_off()
		for toggle_block in toggle_blocks:
			toggle_block.toggle_off()
	return is_toggled


func _on_area_2d_body_entered(body: Node2D) -> void:
	toggle()
