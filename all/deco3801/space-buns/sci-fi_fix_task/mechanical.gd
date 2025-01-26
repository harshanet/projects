extends Pickable
var activated = false
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false
func _ready():
	message = floating_text.instantiate()
	message.message = ""
	message.visible = false
	add_child(message)
func get_type():
	return "Battery"

@rpc("any_peer", "call_local")
func activate():
	activated = true

func get_activation_status():
	return activated


func remove_message():
	message.visible = false
	message_removed = true
