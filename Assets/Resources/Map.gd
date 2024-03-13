extends Resource
class_name Map

var map_width: int
var map_height: int
var level_map: Array[Array]
var entity_map: Array[EntityMap]
var level_start: Vector2
var level_end: Vector2
var level_name: String

class EntityMap:
	var enemy_id: int
	var position: Vector2i
	
	func _init(e_id: int, pos: Vector2i):
		enemy_id = e_id
		position = pos

func _init(level_data: PackedByteArray, width: int = 26, height: int = 16, enemy_count: int = 20):
	map_width = width
	map_height = height
	
	var pos = 0
	
	# Parse the level map data
	level_map = []
	for y in range(height):
		var row = []
		for x in range(width):
			pos = width * y + x
			row.append(level_data[pos])
		level_map.append(row)
		
	# Parse level end
	level_end = Vector2i(level_data[pos+1], level_data[pos+2])
	pos += 2
	
	# Parse level start
	level_start = Vector2i(level_data[pos+1], level_data[pos+2])
	pos += 2
		
	# Parse the enemies
	entity_map = []
	for _e in range(enemy_count):
		entity_map.append(
			EntityMap.new(level_data[pos+1], Vector2i(level_data[pos+2], level_data[pos+3])))
		pos += 3
		
	# Parse the level name
	level_name = ""
	for n in range(pos, len(level_data)):
		level_name += char(level_data[n])
