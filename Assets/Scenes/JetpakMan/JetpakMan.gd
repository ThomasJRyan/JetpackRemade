extends CharacterBody2D
class_name JetpakMan

signal fuel_changed
signal gem_collected

@export var speed = 150.0
@export var jump_velocity = -400.0
@export var flight_velocity = -200.0
@export var fuel = 0:
	set(f):
		fuel = clamp(f, 0, 100)
		emit_signal("fuel_changed")
@export var tile_map : TileMap:
	set(tm):
		tile_map = tm
		current_tile_cords = tile_map.local_to_map(position)
		
@export var MIN_GRAVITY = -100
@export var MAX_GRAVITY = 600

@onready var sprite = $AnimatedSprite2D
@onready var ceiling_raycast = $Raycasts/TopRaycast
@onready var floor_raycast = $Raycasts/BotRaycast
@onready var animation_tree: AnimationTree = $AnimationTree

@onready var state_machine = $CharacterStateMachine

@onready var character_collision = $CharacterCollision

var gameplay_level : GameplayLevel

var direction := Vector2.ZERO

var has_control = true
var on_ladder = 0:
	set(l):
		on_ladder = l
		set_collision_mask_value(4, not is_on_ladder())
var skip_gravity_check = false

var push_left = 0
var push_right = 0
var push_up = 0
var push_down = 0
var sliding = 0
var slowed = 0

var middle_collision = 0
var bottom_collision = 0

var current_tile_cords : Vector2i = Vector2i.ZERO

var SCORE = 0

var switch_number = 0

	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_direction := 0

			
func has_fuel():
	return fuel > 0
	
func is_on_ladder():
	return on_ladder > 0
	
func is_middle_colliding():
	return middle_collision > 0
	
func is_bottom_colliding():
	return bottom_collision > 0
	
func is_sliding():
	return sliding > 0
	
func is_pushed_left():
	return push_left > 0
	
func is_pushed_right():
	return push_right > 0
	
func is_pushed_up():
	return push_up > 0
	
func is_pushed_down():
	return push_down > 0
	
func is_slowed():
	return slowed > 0
	
func check_if_gravity_skipped():
	return is_on_ladder() and not state_machine.current_state is Air
	
func kill():
	state_machine.kill()
	
func flip_switch():
	pass


func _physics_process(delta):
	## Add the gravity.
	#if floor_raycast.is_colliding():
		##skip_gravity_check = true
		#velocity.y = 0
	
	#if not is_on_floor() and not check_if_gravity_skipped() and state_machine.current_state is Air:
	if not is_on_floor() and not check_if_gravity_skipped():
		velocity.y += gravity * delta
		#position.y += 1
	
	## Get input direction
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	## Handle basic movement
	if direction.x != 0 and state_machine.check_if_can_move():
		velocity.x = direction.x * speed
		if is_slowed():
			velocity.x = clamp(velocity.x, -(speed * 0.66), speed * 0.66)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if tile_map:
		current_tile_cords = tile_map.local_to_map(position)
	
	update_direction()
	update_animation()
	move_and_slide()
	
func update_direction():
	if direction.x > 0:
		sprite.flip_h = false
		last_direction = 1
	elif direction.x < 0:
		sprite.flip_h = true
		last_direction = -1
	
func update_animation():
	animation_tree.set("parameters/Move/blend_position", direction.x)


func _on_area_2d_body_shape_entered(body_rid, body: TileMap, body_shape_index, local_shape_index):
	var tile_cords = body.get_coords_for_body_rid(body_rid)
	var tile_data = body.get_cell_tile_data(0, tile_cords)
	if not tile_data:
		return
	var special_interaction: int = tile_data.get_custom_data("special_interaction")
	if not tile_map:
		tile_map = body
	#print("Entering: " + str(special_interaction))
	match special_interaction:
		1: # On ladder
			on_ladder += 1
		2: # On up ladder
			on_ladder += 1
			push_up += 1
		3: # On down ladder
			on_ladder += 1
			push_down += 1
		4: # Collect gem
			SCORE += 50
			emit_signal("gem_collected")
			body.set_cell(0, tile_cords, 0, Vector2i(3, 0))
		9: # Blue switch
			switch_number += 9
		10: # Blue auto switch
			gameplay_level.flip_switch(9)
		11: # Red switch
			switch_number += 11
		12: # Red auto switch
			gameplay_level.flip_switch(11)
		13: # Turqoise switch
			switch_number += 13
		14: # Turqoise auto switch
			gameplay_level.flip_switch(13)
		15: # Fuel tank %100
			fuel += 100
			body.erase_cell(0, tile_cords)
		16: # Fuel tank %50
			fuel += 50
			body.erase_cell(0, tile_cords)
		20: # Coin
			SCORE += 100
			body.erase_cell(0, tile_cords)
		21: # Gold
			SCORE += 150
			body.erase_cell(0, tile_cords)
		22: # Vase
			SCORE += 200
			body.erase_cell(0, tile_cords)
		23: # Extra life
			SCORE += 500
			body.erase_cell(0, tile_cords)
		36:
			kill()

func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	var tile_cords = body.get_coords_for_body_rid(body_rid)
	var tile_data = body.get_cell_tile_data(0, tile_cords)
	if not tile_data:
		return
	var special_interaction: int = tile_data.get_custom_data("special_interaction")
	if not tile_map:
		tile_map = body
	#print("Exiting: " + str(special_interaction))
	match special_interaction:
		1: # Leave ladder
			on_ladder -= 1
		2: # On up ladder
			on_ladder -= 1
			push_up -= 1
		3: # On down ladder
			on_ladder -= 1
			push_down -= 1
		9: # Blue switch
			switch_number -= 9
		11: # Red switch
			switch_number -= 11
		13: # Turqoise switch
			switch_number -= 13
		


func _on_middle_collision_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var tile_cords = body.get_coords_for_body_rid(body_rid)
	var tile_data = body.get_cell_tile_data(0, tile_cords)
	if not tile_data:
		return
	var special_interaction: int = tile_data.get_custom_data("special_interaction")
	match special_interaction:
		1:
			middle_collision += 1
		2:
			middle_collision += 1
		3:
			middle_collision += 1


func _on_middle_collision_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	var tile_cords = body.get_coords_for_body_rid(body_rid)
	var tile_data = body.get_cell_tile_data(0, tile_cords)
	if not tile_data:
		return
	var special_interaction: int = tile_data.get_custom_data("special_interaction")
	match special_interaction:
		1:
			middle_collision -= 1
		2:
			middle_collision -= 1
		3:
			middle_collision -= 1


func _on_bottom_collision_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var tile_cords = body.get_coords_for_body_rid(body_rid)
	var tile_data = body.get_cell_tile_data(0, tile_cords)
	if not tile_data:
		return
	var special_interaction: int = tile_data.get_custom_data("special_interaction")
	#print(special_interaction)
	match special_interaction:
		1:
			bottom_collision += 1
		94: # Ice
			sliding += 1
		97: # Grass
			slowed += 1
		114: # Platforms that push left
			push_left += 1
		117: # Platforms that push left
			push_right += 1


func _on_bottom_collision_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	var tile_cords = body.get_coords_for_body_rid(body_rid)
	var tile_data = body.get_cell_tile_data(0, tile_cords)
	if not tile_data:
		return
	var special_interaction: int = tile_data.get_custom_data("special_interaction")
	match special_interaction:
		1:
			bottom_collision -= 1
		94: # Ice
			sliding -= 1
		97: # Grass
			slowed -= 1
		114:# Platforms that push left
			push_left -= 1
		117: # Platforms that push left
			push_right -= 1
