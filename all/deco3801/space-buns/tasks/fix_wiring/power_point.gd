extends Area2D

@export var switch_on: Texture2D
@export var switch_off: Texture2D
var switch_status = true

@rpc("any_peer", "call_local")
func flick():
	if switch_status == false:
		switch_status = true
		$switch.texture = switch_on
	else:
		switch_status = false
		$switch.texture = switch_off
	get_parent().change_power_on.rpc(switch_status)

func get_type():
	return "PowerPoint"
