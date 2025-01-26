extends Pickable
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false

func _ready():
	message = floating_text.instantiate()
	message.message = "Wooden Stick"
	message.visible = false
	add_child(message)
	message.global_position = $MessagePosition.global_position
	message.rotation_degrees = 90


@rpc("any_peer", "call_local")
func activate():
	var current = $EffectRotation/EffectPosition/StaticBody2D.get_collision_layer_value(8)
	$EffectRotation/EffectPosition/StaticBody2D.set_collision_layer_value(8, !current)
	
func get_type():
	return "WoodenStick"

func _on_body_entered(body):
	if (!message_removed and body.get_type() == "Player"):
		message.visible = true

func _on_body_exited(body):
	if body.get_type() == "Player":
		message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
