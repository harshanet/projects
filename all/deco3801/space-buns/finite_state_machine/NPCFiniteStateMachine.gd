class_name FiniteStateMachine
extends Node

@export var state : State

func _ready():
	if state != null:
		change_state_no_rpc(state)


func change_state(new_state : State):
	if state is State:
		state._exit_state.rpc()
	new_state._enter_state.rpc()
	state = new_state

func change_state_no_rpc(new_state : State):
	if state is State:
		state._exit_state()
	new_state._enter_state()
	state = new_state

func exit_state():
	if state is State:
		state._exit_state()
