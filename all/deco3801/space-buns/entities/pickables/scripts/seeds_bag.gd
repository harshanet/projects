extends Pickable
var planting = false
var plantTime = 0
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false

func _ready():
	message = floating_text.instantiate()
	message.message = "Seeds"
	message.visible = false
	add_child(message)

func _process(delta):
	# plants the seeds for 360 frames
	if planting:
		if plantTime > 360:
			planting = false
		elif planting:
			$Sprite2D.rotation = 60
			plantTime += 1
	else:
		$Sprite2D.rotation = 0
	if $Sprite2D.flip_h == true:
		$Sprite2D.offset.x = 10
	else:
		$Sprite2D.offset.x = -10

@rpc("any_peer", "call_local")
func activate():
	plantTime = 0
	planting = true
	
func is_planting():
	return planting

func get_type():
	return "SeedsBag"

func _on_body_entered(body):
	if (!message_removed and body.get_type() == "Player"):
		message.visible = true

func _on_body_exited(body):
	if body.get_type() == "Player":
		message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true

func remove():
	# we have a remove function that can be called by the task when the player 
	# has planted all the seeds in the bag
	if get_parent().get_type() == "Player":
		get_parent().throw_item.rpc()
