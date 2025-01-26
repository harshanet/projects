extends Area2D
var fixed = false
var charged = false
var text
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var progress_bar
var progress_bar_scene = preload("res://entities/progress_bar/progress_bar.tscn")
var processing = false 
var steps = 0
signal progress
var broken_parts = {
	"Reactor": false,
	"EnergyCore": false,
	"CPU": false,
	"Cooler": false
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var initial_message = "Reactor, EnergyCore, Cooler, CPU broken"
	text = floating_text.instantiate()
	text.message = initial_message
	add_child(text)
	text.global_position.y -= 40
	text.visible = false
	progress_bar = progress_bar_scene.instantiate()
	add_child(progress_bar)
	progress_bar.global_position.y -= 20


func _physics_process(delta):
	if has_overlapping_bodies() and not fixed:
		for body in get_overlapping_bodies():
			if body.has_method("get_type"):
				var picked_item = body.get_picked_item()
				if body.get_type() == "Player" and picked_item != null:
					if picked_item.has_method("get_activation_status") and picked_item.has_method("get_type"):
						var type = picked_item.get_type()
						var activated = picked_item.get_activation_status()
						if broken_parts.has(type) and broken_parts[type] == false and activated and not fixed:
							progress_bar.increment(25)
							broken_parts[type] = true
							steps += 1
							progress.emit()
							if steps == 4:
								fixed = true
								progress_bar.queue_free()
							await get_tree().create_timer(1).timeout
							body.throw_item()



func _on_body_entered(body):
	if not processing and not fixed:
		text.visible = true


func _on_body_exited(body):
	if has_overlapping_bodies() == false:
		text.visible = false
