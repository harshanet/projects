extends Area2D

@export var wire_good: Texture2D
@export var wire_bad_on: Texture2D
@export var wire_bad_off: Texture2D

var wire_status = "bad"
var power = true

@rpc("any_peer", "call_local")
func change_status(status):
	if status == "bad":
		wire_status = "bad"
		get_parent().change_wire_status.rpc(true)
	elif status == "good":
		wire_status = "good"
		get_parent().change_wire_status.rpc(false)
	else:
		pass
	update_texture()

@rpc("any_peer", "call_local")
func change_power(power_status):
	power = power_status
	update_texture()

func update_texture():
	# if its a bad wire and has power, its dangerous and is sparking
	if (wire_status == "bad") and (power == true):
		$Sprite2D.texture = wire_bad_on
		$PointLight2D.visible = true
	elif (wire_status == "bad") and (power == false):
		$Sprite2D.texture = wire_bad_off
		$PointLight2D.visible = false
	else:
		$Sprite2D.texture = wire_good
		$PointLight2D.visible = false

func get_type():
	return "Wire"
