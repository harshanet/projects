extends Area2D

@export var machine_off: Texture2D
@export var machine_on: Texture2D

var on_switch = true
var has_power = false

# the electrical machine is a lamp, light only appear if it is on and has power
@rpc("any_peer", "call_local")
func flick():
	if on_switch == true:
		on_switch = false
		$Sprite2D.texture = machine_off
	else:
		on_switch = true
		$Sprite2D.texture = machine_on
		if has_power == true:
			$PointLight2D.visible = true
		else:
			$PointLight2D.visible = false
	# letting the task scene know that we have changed the switch status
	# of the lamp -> must use rpc so all machines know 
	get_parent().change_machine_on.rpc(on_switch)

@rpc("any_peer", "call_local")
func set_power_status(status):
	has_power = status
	if not has_power:
		$PointLight2D.visible = false
	elif has_power and on_switch:
		$PointLight2D.visible = true

func get_type():
	return "ElectricalMachine"
