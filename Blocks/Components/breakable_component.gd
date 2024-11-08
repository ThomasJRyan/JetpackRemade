extends Area2D

@export var break_frames: SpriteFrames
@export var break_time: float = 1.0
@export var reform_wait: float = 3.0
@export var reform_time: float = 0.25

@onready var block: StaticBody2D = $".."
@onready var timer: Timer = $Timer
@onready var break_animation: AnimatedSprite2D = $AnimatedSprite2D

enum states {
	UNBROKEN,
	BROKEN,
	REFORMING,
}
var state: states = states.UNBROKEN

func _ready():
	break_animation.sprite_frames = break_frames

func break_block():
	""" Activates the block breaking functionality """
	# First, set the player collision value to false
	# so that the player (and enemies) can pass through it
	block.set_collision_layer_value(1, false)
	
	# Second, make the break_animation visible and beging
	# playing the break_animation animation
	break_animation.visible = true
	break_animation.play("default", 5.0, true)
	
	# Set the state to broken so that we aren't trying to
	# break it more times
	state = states.BROKEN
	
	# Wait for the animation to finish and then start the 
	# reformation timer
	await break_animation.animation_finished
	timer.start(reform_wait)
	
	
func reform_block():
	""" Activates the block reforming functionality """
	# Set the state to reforming so we know it's in the
	# in the process of it
	state = states.REFORMING
	
	# Begin the reformation animation (break_animation in reverse
	# and wait for that to finish before setting break_animation
	# visibility to false
	break_animation.play("default", -reform_time, true)
	await break_animation.animation_finished
	break_animation.visible = false
	
	# Re-enable collision for the player and set state
	# back to unbroken
	block.set_collision_layer_value(1, true)
	state = states.UNBROKEN

func _on_area_entered(area: Area2D) -> void:
	"""
	If the area has been entered and the block is unbroken,
	start the timer. We we remain in the area for the duration
	of the timer then we'll timeout and process that action
	accordingly
	"""
	if state == states.UNBROKEN:
		timer.start(break_time)


func _on_area_exited(area: Area2D) -> void:
	"""
	If the area is exited then stop the timer and do not
	attempt to break the block
	"""
	if state == states.UNBROKEN:
		timer.stop()


func _on_timer_timeout() -> void:
	"""
	If we've managed to timeout then check our current state
	and act accordingly
	"""
	match state:
		states.UNBROKEN:
			break_block()
		states.BROKEN:
			reform_block()
