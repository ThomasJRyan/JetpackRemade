extends Sprite2D
class_name Teleporter

@export var colour: Color

@onready var collision = $ShapeCast2D
@onready var timer: Timer = $Timer

var teleporters: Array[Teleporter]

func _enter_tree() -> void:
	material.set_shader_parameter("colour", colour)
	
func _ready() -> void:
	material.set_shader_parameter("colour", colour)
	for teleporter in get_tree().get_nodes_in_group("teleporter"):
		if teleporter == self:
			continue
		if teleporter.colour == colour:
			teleporters.append(teleporter)
			
func _input(event: InputEvent) -> void:
	if len(teleporters) == 0:
		return
	if !collision.is_colliding():
		return
	var player: Player = collision.get_collider(0)
	if player is not Player:
		return
	if Input.is_action_just_pressed("up") and not event.is_echo():
		var teleporter = teleporters.pick_random()
		player.start_teleport(colour)
		timer.start()
		await timer.timeout
		player.position = teleporter.position
		player.stop_teleport()
