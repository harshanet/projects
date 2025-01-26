extends Node2D

@onready var label = get_node("Label")
var message = null
# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_text(message)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
