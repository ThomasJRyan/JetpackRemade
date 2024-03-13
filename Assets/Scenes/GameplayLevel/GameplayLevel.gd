extends Node2D

@onready var tilemap := $TileMap

var JetpackMan = preload("res://Assets/Scenes/JetpakMan/JetpakMan.tscn")
var Door = preload("res://Assets/Scenes/Door/Door.tscn")

@onready var FuelBar = $Control/GridContainer/ColorRect/GridContainer/ProgressBar

var exit_door
var player

var max_gems := 0
@export var collected_gems: int = 0:
	set(gems):
		collected_gems = gems
		if exit_door:
			if collected_gems >= max_gems:
				exit_door.open()
			elif collected_gems < max_gems and exit_door.is_open:
				exit_door.close()

var LEGACY_TILE_MAPPING = {}

func map_legacy_tiles():
	"""Generate a dictionary of legacy tile mappings"""
	var tileset: TileSet = tilemap.tile_set
	var tilesource: TileSetAtlasSource = tileset.get_source(0)
	for i in range(tilesource.get_tiles_count()):
		var cords: Vector2i = tilesource.get_tile_id(i)
		var tiledata: TileData = tilesource.get_tile_data(cords, 0)
		if not tiledata:
			continue
		LEGACY_TILE_MAPPING[tiledata.get_custom_data("legacy_id")] = cords

func load_map(filepath: String):
	"""Load a map into the play area"""
	var content := FileAccess.get_file_as_bytes("res://Assets/Levels/" + filepath)
	var level_data := Map.new(content)
	
	# Iterate through the level data and generate the map
	for y in range(level_data.level_map.size()):
		for x in range(level_data.level_map[y].size()):
			var tile_id = level_data.level_map[y][x]
			if tile_id == 4:
				max_gems += 1
			var tile_vector = LEGACY_TILE_MAPPING.get(tile_id)
			if tile_vector:
				tilemap.set_cell(0, Vector2i(x, y), 0, tile_vector)
				
	
	# Set the ending position
	exit_door = Door.instantiate()
	exit_door.connect("door_reached", level_complete)
	var door_pos: Vector2 = tilemap.to_global(level_data.level_end)
	print(door_pos)
	add_child(exit_door)
	exit_door.position.x = door_pos.x * 36 - 36
	exit_door.position.y = door_pos.y * 36
	
	# Set the starting position
	player = JetpackMan.instantiate()
	player.tile_map = tilemap
	var player_pos: Vector2 = tilemap.to_global(level_data.level_start)
	player.connect("fuel_changed", on_fuel_change)
	player.connect("gem_collected", on_gem_collected)
	add_child(player)
	player.position.x = player_pos.x * 36 - 18
	player.position.y = player_pos.y * 36 - 18
	
	# Place the enemies
			
	print("Map Loaded!")
	
func on_fuel_change():
	if player:
		FuelBar.value = player.fuel
	
func on_gem_collected():
	collected_gems += 1
	
func level_complete():
	print("Level complete!")
	
func _ready():
	map_legacy_tiles()
	#load_map("1_Welcome to Jetpack!.dat")
	#load_map("18_Woof.dat")
