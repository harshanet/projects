extends Pickable
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false

func _ready():
	message = floating_text.instantiate()
	message.message = "Good Wire"
	message.visible = false
	add_child(message)

@rpc("any_peer", "call_local")
func activate():
	pass

func get_type():
	return "GoodWire"

func _on_body_entered(body):
	if (!message_removed and body.get_type() == "Player"):
		message.visible = true

func _on_body_exited(body):
	if body.get_type() == "Player":
		message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
