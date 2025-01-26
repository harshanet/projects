extends Area2D
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message

func _ready():
	message = floating_text.instantiate()
	message.message = "Medical Storage"
	add_child(message)
	message.global_position.y -= 40
	message.visible = false

func open():
	$AnimatedSprite2D.play("open")

func close():
	$AnimatedSprite2D.play("closed")

func get_type():
	return "MedicalStorage"


func _on_body_entered(body):
	message.visible = true

func _on_body_exited(body):
	message.visible = false
