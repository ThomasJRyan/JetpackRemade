extends Area2D

@onready var sprite = $AnimatedSprite2D

signal door_reached

var is_open := false

func open():
	if is_open:
		return
	is_open = true
	sprite.play("Open")
	
func close():
	if not is_open:
		return
	is_open = false
	sprite.play("Close")
	

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("Door interacted with")
	if body is JetpakMan and is_open:
		emit_signal("door_reached")


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("Door area interacted with")
	print(area)
	if area is JetpakMan and is_open:
		emit_signal("door_reached")
