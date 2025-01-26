extends AnimatedSprite2D


func _ready():
	global_position = get_parent().get_node("EffectRotation").get_node("EffectPosition").global_position
	play("drop")
	
func _on_animation_finished():
	self.queue_free()
