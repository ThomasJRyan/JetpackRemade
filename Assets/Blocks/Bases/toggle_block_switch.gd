@tool
extends Sprite2D
class_name ToggleBlockSwitch

@export_category("Variables")
@export var colour: Color

@onready var collision = $ShapeCast2D
@onready var handle = $Sprite2D

var toggle_blocks: Array
var toggle_switches: Array
var is_toggled: bool

var off_offset = Vector2(1, -2)
var on_offset = Vector2(0, 0)

func _enter_tree() -> void:
	# Set the colour of the toggle block switch in the shader
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
			
func _input(event: InputEvent) -> void:
	# Check if something is colliding with the switch
	if !collision.is_colliding():
		return
	# Check if the collider is the player
	if !collision.get_collider(0) is Player:
		return
	# Check if the player is pressing the up key then toggle the switch
	if Input.is_action_just_pressed("up") and not event.is_echo():
		toggle()
			
func toggle_on() -> void:
	"""
	Toggles the switch on, changing the offset and showing the handle
	"""
	is_toggled = false
	offset = off_offset
	handle.visible = true
	
func toggle_off() -> void:
	"""
	Toggles the switch off, changing the offset and hiding the handle
	"""
	is_toggled = true
	offset = on_offset
	handle.visible = false
	
func toggle() -> bool:
	"""
	Toggles the switch on or off depending on the current state
	Toggles all the toggle blocks and switches in the scene

	Returns:
		bool: The state of the switch after toggling
	"""

	# I wanted to use the `toggle()` functions on each, but turns out
	# that's a great way to mess up your state. So instead I'm just
	# going to manually toggle them all exactly how I want them
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
