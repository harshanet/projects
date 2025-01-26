extends Area2D
var done = false
var text
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var progress_bar
var progress_bar_scene = preload("res://entities/progress_bar/progress_bar.tscn")
var processing = false 

signal completed
# Called when the node enters the scene tree for the first time.
func _ready():
	var initial_message = "Needs Elixir"
	text = floating_text.instantiate()
	text.message = initial_message
	add_child(text)
	text.global_position.y -= 70
	text.visible = false

func _physics_process(delta):
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			if body.has_method("get_type"):
				var picked_item = body.get_picked_item()
				if body.get_type() == "Player" and picked_item != null:
					if picked_item.has_method("get_activation_status") and picked_item.has_method("get_type"):
						var type = picked_item.get_type()
						var activated = picked_item.get_activation_status()
						if type == "ChemicalElixir" and activated and not done:
							done = true
							completed.emit()
							await get_tree().create_timer(1).timeout
							body.throw_item()

func _on_body_entered(body):
	if not done:
		text.visible = true


func _on_body_exited(body):
	if has_overlapping_bodies() == false:
		text.visible = false

