extends MedicalItem
var water = preload("res://entities/effects/water.tscn")
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false
func _ready():
	message = floating_text.instantiate()
	message.message = "Cold water"
	add_child(message)
	message.visible = false

func get_type():
	return "ColdWater"

@rpc("any_peer", "call_local")
func activate():
	if activatable:
		if $Sprite2D.flip_h == false:
			$Sprite2D.rotation_degrees = 65
		else:
			$Sprite2D.rotation_degrees = -115
		var effect = water.instantiate()
		add_child(effect)
		await(effect.animation_finished)
		activated = true

func _on_body_entered(body):
	if (!message_removed):
		message.visible = true

func _on_body_exited(body):
	message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
