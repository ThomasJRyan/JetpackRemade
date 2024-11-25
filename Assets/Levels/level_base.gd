extends Node2D

var player: Player 
var door: Door

var max_gems: int
var collected_gems: int

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	door = get_tree().get_nodes_in_group("door")[0]
	
	max_gems = get_tree().get_node_count_in_group("gem")
	for gem in get_tree().get_nodes_in_group("gem"):
		gem.connect("gem_collected", _gem_collected)
	
func _gem_collected():
	collected_gems += 1
	if collected_gems >= max_gems:
		door.open()
