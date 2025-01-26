extends Pickable
@onready var waterMist = preload("res://tasks/harvest_plants/water_mist.tscn")
var mist
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false

func _ready():
	message = floating_text.instantiate()
	message.message = "Water Spray"
	message.visible = false
	add_child(message)
	
func _process(delta):
	if $Sprite2D.flip_h == true:
		$Sprite2D.offset.x = 0
	else:
		$Sprite2D.offset.x = 0

@rpc("any_peer", "call_local")
func activate():
	mist = waterMist.instantiate()
	get_parent().get_parent().add_child(mist) # puts the mist in a position 
	# relative to the map so that it doesnt move with the player 
	if $Sprite2D.flip_h == false:
		$Node2D.position.x = 4
		$Node2D.position.y = -6
	else:
		mist.get_node("AnimatedSprite2D").flip_h = true
		$Node2D.position.x = -60
		$Node2D.position.y = -6
		mist.get_node("CollisionShape2D").position.x = -16
	mist.global_position = $Node2D.global_position

func get_type():
	return "WaterSprayBottle"

func _on_body_entered(body):
	if (!message_removed and body.get_type() == "Player"):
		message.visible = true

func _on_body_exited(body):
	if body.get_type() == "Player":
		message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
