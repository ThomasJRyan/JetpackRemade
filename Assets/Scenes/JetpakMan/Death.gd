extends State
class_name Death

@export var death_animations : Array[String] = ["Death1", "Death2", "Death3", "Death4"]

func on_enter():
	var death_anim = death_animations[randi_range(0, len(death_animations) - 1)]
	playback.travel(death_anim)
