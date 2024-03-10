extends Node

class_name State

@export var can_move : bool = true
@export var is_centered : bool = false

var animation_player : AnimationPlayer
var playback : AnimationNodeStateMachinePlayback
var character : CharacterBody2D
var next_state : State

func state_process(delta):
	pass

func state_input(event: InputEvent):
	pass

func on_enter():
	pass

func on_exit():
	pass
