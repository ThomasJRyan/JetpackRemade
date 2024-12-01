extends Sprite2D
class_name ToggleBlockSwitchAuto

@export var colour: Color

@onready var collision = $ShapeCast2D

var toggle_blocks: Array
var toggle_switches: Array
var is_toggled: bool

func _enter_tree() -> void:
	material.set_shader_parameter("colour", colour)
	
func _ready() -> void:
	material.set_shader_parameter("colour", colour)
	for toggle_block in get_tree().get_nodes_in_group("toggle_block"):
		if toggle_block.colour == colour:
			toggle_blocks.append(toggle_block)
	for toggle_switch in get_tree().get_nodes_in_group("toggle_switch"):
		if toggle_switch.colour == colour:
			toggle_switches.append(toggle_switch)

func toggle_on() -> void:
	is_toggled = false
	
func toggle_off() -> void:
	is_toggled = true
	
func toggle() -> bool:
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
