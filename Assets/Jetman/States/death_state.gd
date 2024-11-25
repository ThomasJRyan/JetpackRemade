extends State
class_name DeathState

signal player_dead

func enter() -> void:
	parent.velocity.x = 0
	parent.animations.play("death_" + str(parent.death_by + 1))
	await parent.animations.animation_finished
	emit_signal("player_dead")

func process_physics(delta: float) -> State:
	if parent.velocity.y < terminal_velocity:
		parent.velocity.y += gravity * delta
		
	parent.move_and_slide()
		
	return null
