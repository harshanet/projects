extends Pickable
var cleaning = false
var cleanTime = 0
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false

func _ready():
	message = floating_text.instantiate()
	message.message = "Mop"
	message.visible = false
	add_child(message)

func _process(delta):
	if cleaning == true:
		if cleanTime > 180:
			cleaning = false
		elif cleaning:
			$AnimatedSprite2D.animation = "cleaning"
			cleanTime += 1
	else:
		$AnimatedSprite2D.animation = "idle"
	if $AnimatedSprite2D.flip_h == true:
		$AnimatedSprite2D.offset.x = 10
	else:
		$AnimatedSprite2D.offset.x = -10

@rpc("any_peer", "call_local")
func activate():
	cleanTime = 0
	cleaning = true
	
func is_cleaning():
	return cleaning

func get_type():
	return "Mop"

func _on_body_entered(body):
	if (!message_removed and body.get_type() == "Player"):
		message.visible = true

func _on_body_exited(body):
	if body.get_type() == "Player":
		message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
