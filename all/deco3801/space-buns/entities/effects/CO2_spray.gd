extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = get_parent().get_node("EffectRotation").get_node("EffectPosition").global_position
	$AnimatedSprite2D.play("spray")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_type():
	return "CO2"

func _on_animated_sprite_2d_animation_finished():
	self.queue_free()
