extends MedicalItem
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	message = floating_text.instantiate()
	message.message = "Epipen"
	add_child(message)
	message.visible = false

func get_type():
	return "EpinephrineInjector"


func _on_body_entered(body):
	if (!message_removed):
		message.visible = true

func _on_body_exited(body):
	message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
