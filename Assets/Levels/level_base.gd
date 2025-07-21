"""
This script is attached to the root node of each level scene.
It initializes the level and keeps track of the player's progress.

The level scene must have the following nodes:
	- A Player node
	- A Door node
	- One or more Gem nodes
"""
extends Node2D

var player: Player 
var door: Door

var max_gems: int
var collected_gems: int

func _input(event):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	door = get_tree().get_nodes_in_group("door")[0]
	
	# Connect the gem_collected signal from each gem to the _gem_collected 
	# function and count the number of gems in the level.
	max_gems = get_tree().get_node_count_in_group("gem")
	for gem in get_tree().get_nodes_in_group("gem"):
		gem.connect("gem_collected", _gem_collected)
		
	if max_gems == 0:
		door.open()
	
func _gem_collected():
	"""
	Called when a gem is collected.
	Add 1 to the collected_gems counter and check if the player has collected 
	all the gems. If so, open the door.
	"""
	collected_gems += 1
	if collected_gems >= max_gems:
		door.open()
