extends Pickable
@onready var smokeSpray = preload("res://scenes/main/disinfectant_gas.tscn")
var spray
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false

func _ready():
	# add floating message to the item when a player is nearby to it
	message = floating_text.instantiate()
	message.message = "Disinfectant"
	message.visible = false
	add_child(message)
	
func _process(delta):
	$Sprite2D.offset.x = 0

@rpc("any_peer", "call_local")
func activate():
	# when the disinfectant is activated, 
	# create a smoke spray child and set its position 
	spray = smokeSpray.instantiate()
	get_parent().get_parent().add_child(spray)
	if $Sprite2D.flip_h == false:
		$Node2D.position.x = 4
		$Node2D.position.y = -6
	else:
		spray.get_node("AnimatedSprite2D").flip_h = true
		$Node2D.position.x = -60
		$Node2D.position.y = -6
		spray.get_node("CollisionShape2D").position.x = -16
	spray.global_position = $Node2D.global_position

func get_type():
	return "DisinfectantSpray"

func _on_body_entered(body):
	if (!message_removed and body.get_type() == "Player"):
		message.visible = true

func _on_body_exited(body):
	if body.get_type() == "Player":
		message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
