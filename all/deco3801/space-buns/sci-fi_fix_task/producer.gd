class_name Producer
extends Area2D
var text = null
@onready var progress_timer = $Timer
var progress_bar
var processing = false
var initial_message = "Battery Producer"
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var progress_bar_scene = preload("res://entities/progress_bar/progress_bar.tscn")
@export var device_scene : PackedScene
var device 
# Called when the node enters the scene tree for the first time.

func _ready():
	text = floating_text.instantiate()
	text.message = initial_message
	add_child(text)
	text.global_position.y -= 30
	text.visible = false

func get_type():
	return "BatteryProducer"

@rpc("any_peer", "call_local")
func activate():
	if device == null:
		progress_bar = progress_bar_scene.instantiate()
		add_child(progress_bar)
		progress_bar.global_position.y -= 30
		text.visible = false
		progress_timer.start()
		await progress_bar.completed
		progress_bar.queue_free()
		progress_timer.stop()
		device = device_scene.instantiate()
		get_parent().add_child(device)
		device.global_position = $ProducingLocation.global_position
		processing = false

@rpc("any_peer", "call_local")
func start_processing():
	if device == null:
		processing = true

func _on_body_entered(body):
	if not processing:
		text.visible = true

func _on_body_exited(body):
	text.visible = false

func _on_timer_timeout():
	progress_bar.increment(10)
	progress_timer.start()
