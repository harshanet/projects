extends Area2D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().name
