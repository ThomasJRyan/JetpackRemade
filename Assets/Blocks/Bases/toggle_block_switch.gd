extends Sprite2D
class_name ToggleBlockSwitch

@export var colour: Color

@onready var collision = $ShapeCast2D
@onready var handle = $Sprite2D

var toggle_blocks: Array
var toggle_switches: Array
var is_toggled: bool

var off_offset = Vector2(1, -2)
var on_offset = Vector2(0, 0)

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
			
func _input(event: InputEvent) -> void:
	if !collision.is_colliding():
		return
	if !collision.get_collider(0) is Player:
		return
	if Input.is_action_just_pressed("up") and not event.is_echo():
		toggle()
			
func toggle_on() -> void:
	is_toggled = false
	offset = off_offset
	handle.visible = true
	
func toggle_off() -> void:
	is_toggled = true
	offset = on_offset
	handle.visible = false
	
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
