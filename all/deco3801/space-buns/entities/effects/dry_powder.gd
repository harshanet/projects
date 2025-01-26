extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = get_parent().get_node("EffectRotation").get_node("EffectPosition").global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_existence_timeout():
	self.queue_free()
	
func get_type():
	return "DryPowder"
