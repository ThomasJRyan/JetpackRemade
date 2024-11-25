extends State

signal finished_dancing

func enter():
	for i in range(3):
		parent.animations.play(animation_name)
		await parent.animations.animation_finished
	emit_signal("finished_dancing")
