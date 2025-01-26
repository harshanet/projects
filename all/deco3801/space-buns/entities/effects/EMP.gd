extends Area2D


# put the emp on the position of the player's effect position
func _ready():
	global_position = get_parent().get_node("EffectRotation").get_node("EffectPosition").global_position
	$AnimatedSprite2D.play("effect")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.

	
func get_type():
	return "Electromagnetic Pulse"


