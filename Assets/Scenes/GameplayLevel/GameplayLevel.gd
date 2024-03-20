extends Node2D
class_name GameplayLevel

@onready var tilemap := $TileMap

var JetpackMan = preload("res://Assets/Scenes/JetpakMan/JetpakMan.tscn")
var Door = preload("res://Assets/Scenes/Door/Door.tscn")

@onready var FuelBar = $Control/GridContainer/ColorRect/GridContainer/ProgressBar

var exit_door
var player

var level_data : Map
var level_width : int = 26
var level_height : int = 16

static var switches_active = {
	9: true,
	11: true,
	13: true,
}

var GATE_MAP = {
	9: [Vector2i(14, 3), Vector2i(15, 3)],
	11: [Vector2i(16, 3), Vector2i(17, 3)],
	13: [Vector2i(18, 3), Vector2i(19, 3)],
}

var SWITCH_MAP = {
	9: [Vector2i(7, 0), Vector2i(8, 0)],
	11: [Vector2i(9, 0), Vector2i(10, 0)],
	13: [Vector2i(11, 0), Vector2i(12, 0)],
}

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

func set_gates(switch_num : int):
	var atlas_vert = GATE_MAP[switch_num][0]
	var atlas_horz = GATE_MAP[switch_num][1]
	
	var vert_tiles = tilemap.get_used_cells_by_id(0, -1, atlas_vert)
	var horz_tiles = tilemap.get_used_cells_by_id(0, -1, atlas_horz)
	
	for tile_cords in vert_tiles:
		tilemap.set_cell(0, tile_cords, 0, atlas_vert, int(switches_active[switch_num]))
	for tile_cords in horz_tiles:
		tilemap.set_cell(0, tile_cords, 0, atlas_horz, int(switches_active[switch_num]))

func set_switches(switch_num : int):
	var atlas_on = SWITCH_MAP[switch_num][0]
	var atlas_off = SWITCH_MAP[switch_num][1]
	
	var on_tiles = tilemap.get_used_cells_by_id(0, -1, atlas_on)
	var off_tiles = tilemap.get_used_cells_by_id(0, -1, atlas_off)
	
	if switches_active[switch_num]:
		for tile_cords in on_tiles:
			tilemap.set_cell(0, tile_cords, 0, atlas_off)
	elif not switches_active[switch_num]:
		for tile_cords in off_tiles:
			tilemap.set_cell(0, tile_cords, 0, atlas_on) 

func flip_switch(switch_num : int):
	set_switches(switch_num)
	set_gates(switch_num)
	switches_active[switch_num] = not switches_active[switch_num]
	
func setup_switches():
	for switch_num in switches_active:
		var atlas_off = SWITCH_MAP[switch_num][1]
		var off_tiles = tilemap.get_used_cells_by_id(0, -1, atlas_off)
		if off_tiles:
			flip_switch(switch_num)

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

func setup_player(plyr : JetpakMan):
	player = plyr
	player.gameplay_level = self
	player.tile_map = tilemap
	player.connect("fuel_changed", on_fuel_change)
	player.connect("gem_collected", on_gem_collected)
	add_child(player)
	
	if level_data:
		var player_pos: Vector2 = tilemap.to_global(level_data.level_start)
		player.position.x = player_pos.x * 36 - 18
		player.position.y = player_pos.y * 36 - 18
	

func load_map(filepath: String):
	"""Load a map into the play area"""
	var content := FileAccess.get_file_as_bytes("res://Assets/Levels/" + filepath)
	level_data = Map.new(content)
	
	level_width = level_data.map_width
	level_height = level_data.map_height
	
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
	var plyr = JetpackMan.instantiate()
	setup_player(plyr)
	
	# Place the enemies
			
	print("Map Loaded!")
	
func on_fuel_change():
	if player:
		FuelBar.value = player.fuel
	
func on_gem_collected():
	collected_gems += 1
	
func level_complete():
	print("Level complete!")
	
func debug_setup():
	for child in get_children():
		if child is JetpakMan:
			setup_player(child)
	
	for child in $Enemies.get_children():
		child.gameplay_level = self
		child.tile_map = tilemap
			
	
#func setup_tiles():
	#for cell_cords in tilemap.get_used_cells(0):
		#var cell_data = tilemap.get_cell_tile_data(0, cell_cords)
		#var tile_id = cell_data.get_custom_data("legacy_id")
		#tiles[cell_cords] = Tile.new(int(tile_id))
	
func _ready():
	map_legacy_tiles()
	debug_setup()
	setup_switches()
	#load_map("1_Welcome to Jetpack!.dat")
	#load_map("18_Woof.dat")
	#setup_tiles()
