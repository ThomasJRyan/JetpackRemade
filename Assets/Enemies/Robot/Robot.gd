extends CharacterBody2D

@export var speed = 150.0
@export var climbing_velocity = 2

var gameplay_level : GameplayLevel
var tile_map : TileMap:
	set(tm):
		tile_map = tm
		update_path()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var astar_grid = AStarGrid2D.new()

var current_tile_cords : Vector2i
var current_path : PackedVector2Array = []
var next_tile : Vector2i
var next_move : Vector2i

var reached_next_tile : bool = true

var direction = 1
@onready var left_ray : RayCast2D = $LeftRay
@onready var right_ray : RayCast2D = $RightRay

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

@export var paused : bool

@onready var state_machine = $RobotStateMachine

var on_ladder = 0:
	set(l):
		on_ladder = l
		set_collision_mask_value(4, not is_on_ladder())

func is_on_ladder():
	return on_ladder > 0
	
func check_if_gravity_skipped():
	return is_on_ladder()

func init_grid():
	astar_grid.size = Vector2i(26, 16)
	astar_grid.cell_size = Vector2i(36, 36)
	astar_grid.offset = Vector2i(36, 36) / 2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()
	
func update_path():
	if not tile_map:
		return
		
	current_tile_cords = tile_map.local_to_map(position)
	for tile_cords in tile_map.get_used_cells(0):
		var tile_data = tile_map.get_cell_tile_data(0, tile_cords)
		var is_solid : bool = tile_data.get_custom_data("is_solid")
		astar_grid.set_point_solid(tile_cords, is_solid)
	current_path = PackedVector2Array(astar_grid.get_point_path(current_tile_cords, gameplay_level.player.current_tile_cords))
	if len(current_path) > 1:
		next_tile = current_path[1]
	$Debug/Line2D.points = current_path

func is_x_centered():
	var tile_center = tile_map.map_to_local(tile_map.local_to_map(position))
	return tile_center.x + 1 > position.x and position.x > tile_center.x - 1
	
func is_y_centered():
	var tile_center = tile_map.map_to_local(tile_map.local_to_map(position))
	return tile_center.y + 1 > position.y and position.y > tile_center.y - 1

func is_centered():
	return is_x_centered() and is_y_centered()

func check_rays():
	if not is_on_floor():
		return
	if left_ray.is_colliding() and right_ray.is_colliding():
		direction = 0
	elif left_ray.is_colliding():
		direction = 1
	elif right_ray.is_colliding():
		direction = -1
		
func update_direction():
	if direction > 0:
		sprite.flip_h = false
	if direction < 0:
		sprite.flip_h = true
		
func update_next_move():
	if len(current_path) > 2:
		next_tile = tile_map.local_to_map(current_path[1])
		next_move = next_tile - current_tile_cords
		
func _ready():
	init_grid()
	update_path()

func _physics_process(delta):
	check_rays()
	update_direction()
	move_and_slide()
	

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is JetpakMan:
		body.kill()
		return
		
	var tile_cords = body.get_coords_for_body_rid(body_rid)
	var tile_data = body.get_cell_tile_data(0, tile_cords)
	if not tile_data:
		return
	var special_interaction: int = tile_data.get_custom_data("special_interaction")
	if not tile_map:
		tile_map = body
	match special_interaction:
		1: # On ladder
			on_ladder += 1



func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is JetpakMan:
		return
		
	var tile_cords = body.get_coords_for_body_rid(body_rid)
	var tile_data = body.get_cell_tile_data(0, tile_cords)
	if not tile_data:
		return
	var special_interaction: int = tile_data.get_custom_data("special_interaction")
	if not tile_map:
		tile_map = body
	match special_interaction:
		1: # Leave ladder
			on_ladder -= 1
