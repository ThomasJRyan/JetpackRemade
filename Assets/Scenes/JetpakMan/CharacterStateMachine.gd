extends Node

class_name CharacterStateMachine

@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
@export var character : CharacterBody2D
@export var current_state : State

var states : Array[State]
var death_state : Death

func _ready():
	for child in get_children():
		if (child is State):
			if child is Death:
				death_state = child
			states.append(child)
			child.character = character
			child.playback = animation_tree["parameters/playback"]
			child.animation_player = animation_player
		else:
			push_warning("Child " + child.name + " is not a State")

func _physics_process(delta):
	if current_state.next_state != null:
		switch_states(current_state.next_state)
		
	current_state.state_process(delta)

func check_if_can_move():
	return current_state.can_move and not character.is_sliding() and not current_state is Death

func kill():
	switch_states(death_state)

func switch_states(new_state : State):
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
		
	current_state = new_state
	current_state.on_enter()
	
func _input(event : InputEvent):
	current_state.state_input(event)
