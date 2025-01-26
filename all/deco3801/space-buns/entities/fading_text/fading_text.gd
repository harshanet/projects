extends Node2D

@onready var label = get_node("Label")
var message = null
var duration = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_text(message)
	
func fade():
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'modulate', Color(1, 1, 1, 0), duration)
	tween.tween_callback(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
