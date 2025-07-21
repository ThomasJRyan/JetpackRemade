extends CharacterBody2D
class_name Bat

@export var speed: int = 50

@onready var state_machine: StateMachine = $StateMachine
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

@onready var label: Label = $Debug/Label

var player: Player

func get_player_direction_x() -> int:
	var move_x = int(player.position.x) - int(position.x)
	if move_x > 0:
		return 1
	if move_x < 0:
		return -1
	return 0
	
func get_player_direction_y() -> int:
	var move_y = int(player.position.y) - int(position.y) - 7
	if move_y > 0:
		return 1
	if move_y < 0:
		return -1
	return 0
	
func get_player_direction() -> Vector2i:
	if not player:
		return Vector2i(0,0)
	return Vector2i(
		get_player_direction_x(),
		get_player_direction_y()
	)

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	state_machine.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	var direction = get_player_direction()
	label.text = str(direction.x) + " " + str(direction.y)
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
