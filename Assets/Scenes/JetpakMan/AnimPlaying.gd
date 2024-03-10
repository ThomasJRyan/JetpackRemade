extends Label

@export var anim_player : AnimatedSprite2D

func _process(delta):
	text = "AnimPlay: " + str(anim_player.is_playing())
