extends Pickable
var projectile_object = preload("res://entities/effects/bullets/bullet2.tscn")
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false
func _ready():
	message = floating_text.instantiate()
	message.message = "Energy Gun"
	message.visible = false
	add_child(message)

@rpc("any_peer", "call_local")
func activate():
	var projectile = projectile_object.instantiate()
	projectile.global_position = $EffectRotation/EffectPosition.global_position
	projectile.rotation_degrees = $EffectRotation.rotation_degrees 
	get_parent().get_parent().add_child(projectile)

func get_type():
	return "Gun1"
	
func _on_body_entered(body):
	if (!message_removed):
		message.visible = true

func _on_body_exited(body):
	message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
