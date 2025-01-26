extends Area2D

func _on_existence_timeout():
	self.queue_free()

func get_type():
	return "WaterMist"
