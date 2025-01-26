extends Area2D
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_existence_timeout():
	self.queue_free()

func get_type():
	return "DisinfectantGas"
