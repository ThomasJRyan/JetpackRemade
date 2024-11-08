extends StaticBody2D
class_name Block

@onready var sprite = $Sprite2D

@export var sprite_texture: Texture

func _ready() -> void:
	sprite.texture = sprite_texture
