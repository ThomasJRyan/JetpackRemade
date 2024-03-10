extends Area2D

@onready var sprite = $AnimatedSprite2D

var is_open := false

func open():
	is_open = true
	sprite.play("Open")
	
func close():
	is_open = false
	sprite.play("Close")
