extends Area2D
var text = null
var status = false
@onready var progress_timer = $Timer
var progress_bar
var initial_message = "Voting Machine"
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var progress_bar_scene = preload("res://entities/progress_bar/progress_bar.tscn")


func _ready():
	text = floating_text.instantiate()
	text.message = initial_message
	add_child(text)

func get_type():
	return "RoboticPoliceManager"

func set_status(value):
	status = value

@rpc("any_peer", "call_local")
func activate(target_all):
	for player in get_tree().get_nodes_in_group("player"):
		if player.name == GameManager.wanted_id:
			player.set_collision_layer_value(13, true)
	progress_bar = progress_bar_scene.instantiate()
	add_child(progress_bar)
	text.visible = false
	progress_timer.start()
	await progress_bar.completed
	progress_bar.queue_free()
	progress_timer.stop()
	status = true
	Signals.ActivateRobots.emit(target_all)
	text.visible = true

func get_status():
	return status

func _on_timer_timeout():
	progress_bar.increment(10)
	progress_timer.start()
