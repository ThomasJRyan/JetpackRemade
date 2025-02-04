extends CharacterBody2D

@export var speed: int = 50

var player: Player

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	
func get_speed(player: float, diamond: float) -> int:
	var move = int(player) - int(diamond)
	if move > 0:
		return 1
	if move < 0:
		return -1
	return 0

func _physics_process(delta: float) -> void:
	var x_move = get_speed(player.position.x, position.x)
	var y_move = get_speed(player.position.y, position.y)
	
	velocity.x = x_move * speed
	velocity.y = y_move * speed
	
	move_and_slide()
