extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

@export var speed = 50

enum direction {
	UP = 1,
	UP_RIGHT = 2,
	RIGHT = 3,
	DOWN_RIGHT = 4,
	DOWN = 5,
	DOWN_LEFT = 6,
	LEFT = 7,
	UP_LEFT = 8,
}

func set_direction() -> void:
	# Get a new direction
	var current_direction = direction.values().pick_random()
	
	# Update sprite
	var region: Rect2 = sprite.get_region_rect()
	region.position.x = current_direction * 12
	sprite.set_region_rect(region)
	
	# Update speeds
	match current_direction:
		1:
			velocity = Vector2(0, -speed)
		2:
			velocity = Vector2(speed, -speed)
		3:
			velocity = Vector2(speed, 0)
		4:
			velocity = Vector2(speed, speed)
		5:
			velocity = Vector2(0, speed)
		6:
			velocity = Vector2(-speed, speed)
		7:
			velocity = Vector2(-speed, 0)
		8:
			velocity = Vector2(-speed, -speed)

func _ready() -> void:
	set_direction()

func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_timer_timeout() -> void:
	set_direction()
