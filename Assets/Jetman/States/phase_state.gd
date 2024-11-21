extends State
class_name PhaseState

@export_category("States")
@export var idle_state: State
@export var walk_state: State
@export var jump_state: State
@export var fly_state: State

@export_category("Raycasts")
@export var foot_raycast: FeetRayCast

@onready var left_phaser = $"../../Phasers/Area2D/LeftPhaser"
@onready var right_phaser = $"../../Phasers/Area2D/RightPhaser"
@onready var up_phaser = $"../../Phasers/Area2D/UpPhaser"
@onready var down_phaser = $"../../Phasers/Area2D/DownPhaser"


func handle_direction(direction: Vector2) -> void:
	left_phaser.disabled = direction.x != -1
	right_phaser.disabled = direction.x != 1
	up_phaser.disabled = direction.y != -1
	down_phaser.disabled = direction.y != 1

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		if parent.fuel > 0:
			return fly_state
		return jump_state
	return null

func process_physics(delta: float) -> State:
	if foot_raycast.is_a_foot_colliding_with("Climbable"):
		parent.velocity.y = 0
	else:
		if parent.velocity.y < terminal_velocity:
			parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("left", "right") * move_speed
	parent.direction = movement
	
	if !Input.is_action_pressed("phaser"):
		if movement:
			return walk_state
		return idle_state
		
	var direction = Input.get_vector("left", "right", "up", "down")
	if not direction:
		direction = Vector2(1 if parent.direction > 0 else -1, 0)
	handle_direction(direction)
	
	if direction.y == 1:
		parent.animations.play("phaser_down")
	elif direction.y == -1:
		parent.animations.play("phaser_up")
	else:
		parent.animations.play("phaser")
		
	parent.animations.flip_h = parent.direction < 0
	parent.velocity.x = movement * parent.speed_modifier
	parent.move_and_slide()
	
	return null

func exit() -> void:
	left_phaser.disabled = true
	right_phaser.disabled = true
	up_phaser.disabled = true
	down_phaser.disabled = true
