extends Pickable
@onready var spray_object= preload("res://entities/effects/dry_powder.tscn")
var spray
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false
func _ready():
	message = floating_text.instantiate()
	message.message = "Powder Extinguisher"
	message.visible = false
	add_child(message)

@rpc("any_peer", "call_local")
func activate():
	spray = spray_object.instantiate()
	add_child(spray)

func get_type():
	return "FireExtinguisherPowder"

func _on_body_entered(body):
	if (!message_removed):
		message.visible = true

func _on_body_exited(body):
	message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true

