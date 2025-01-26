extends Area2D
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message

func _ready():
	message = floating_text.instantiate()
	message.message = "Mechanical Storage"
	add_child(message)
	message.global_position.y -= 60
	message.visible = false

func get_type():
	return "MechanicalStorage"

func _on_body_entered(body):
	message.visible = true

func _on_body_exited(body):
	message.visible = false
