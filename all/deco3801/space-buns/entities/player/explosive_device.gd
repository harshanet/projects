extends Node2D
var explosion = preload("res://entities/player/explosion_c4.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	await $Timer.timeout
	var effect = explosion.instantiate()
	get_parent().add_child(effect)
	effect.global_position = global_position
	self.queue_free()
	

