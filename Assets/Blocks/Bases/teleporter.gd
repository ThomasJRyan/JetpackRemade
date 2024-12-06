@tool
extends Sprite2D
class_name Teleporter

@export_category("Variables")
@export var colour: Color

@export_category("Nodes")
@onready var collision = $ShapeCast2D
@onready var timer: Timer = $Timer

var teleporters: Array[Teleporter]

func _enter_tree() -> void:
	# Set the colour of the teleporter in the shader
	# Used for changing colour in the editor
	material.set_shader_parameter("colour", colour)
	
func _ready() -> void:
	# Get all teleporters in the scene with the same colour
	for teleporter in get_tree().get_nodes_in_group("teleporter"):
		# Skip self so we don't teleport to ourselves
		if teleporter == self:
			continue
		if teleporter.colour == colour:
			teleporters.append(teleporter)
			
func _input(event: InputEvent) -> void:
	# Check that we have teleporters to teleport to
	if len(teleporters) == 0:
		return
	# Check if something is colliding with the teleporter
	if !collision.is_colliding():
		return
	# Check if the player is colliding with the teleporter
	var player: Player = collision.get_collider(0)
	if player is not Player:
		return

	# Check if the player is pressing the up key
	# If they are, teleport them to a random teleporter
	if Input.is_action_just_pressed("up") and not event.is_echo():
		var teleporter = teleporters.pick_random()

		# TODO: I'm not happy with this. We're relying on functions on the
		# player to set the player's teleporter shader. In an ideal world
		# we could have some other way of doing this. Maybe a signal?
		player.start_teleport(colour)

		# Wait for the teleporter to finish teleporting
		timer.start()
		await timer.timeout
		player.position = teleporter.position

		# ! This is such a hack...
		player.stop_teleport()
