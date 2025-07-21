extends Node

#func _input(event):
	#if Input.is_action_just_pressed("pause"):
		#get_tree().paused = !get_tree().paused
