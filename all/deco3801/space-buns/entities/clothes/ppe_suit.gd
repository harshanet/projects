extends Area2D
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message

# PPE suit is part of the players clothing just like lab coat and mask 
func _ready():
	message = floating_text.instantiate()
	message.message = "PPE Suit"
	add_child(message)
	message.global_position = $MessagePosition.global_position
	message.visible = false
#Used to show popup message
func _on_body_entered(body):
	if body.has_method("get_type") and body.get_type() == "Player":
		message.show()

#Used to hide popup message
func _on_body_exited(body):
	if body.has_method("get_type") and body.get_type() == "Player":
		message.hide()

@rpc("any_peer", "call_local")
func delete():
	self.queue_free()
	
func get_type():
	return "PPESuit"
