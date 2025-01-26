extends MedicalItem
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false
func _ready():
	message = floating_text.instantiate()
	message.message = "Bandage inside"
	add_child(message)
	message.visible = false

func get_type():
	return "Bandage"


func _on_body_entered(body):
	if (!message_removed):
		message.visible = true

func _on_body_exited(body):
	message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
