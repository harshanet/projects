extends Pickable
var harvesting = false
var harvestTime = 0
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false

func _ready():
	message = floating_text.instantiate()
	message.message = "Harvest Items"
	message.visible = false
	add_child(message)

func _process(delta):
	# when activated, it harvests for 121 frames
	# process sets the animations appropriately. The basket is in a different
	# relative location if it is being held by a player or not
	if harvesting:
		if harvestTime > 121:
			harvesting = false
			$AnimatedSprite2D.animation = "idle"
		elif $AnimatedSprite2D.animation != "harvesting":
			$AnimatedSprite2D.animation = "harvesting"
		harvestTime += 1
	# put the position of the sprites in the correct location
	if get_parent().get_type() == "Player":
		if $AnimatedSprite2D.flip_h:
			$Basket.position.x = 22
			$Basket.position.y = 8
		else:
			$Basket.position.x = -22
			$Basket.position.y = 8
	else:
		$Basket.position.x = 15
		$Basket.position.y = -5

@rpc("any_peer", "call_local")
func activate():
	harvestTime = 0
	harvesting = true
	
func is_harvesting():
	return harvesting

func get_type():
	return "HarvestTool"

func _on_body_entered(body):
	if (!message_removed and body.get_type() == "Player"):
		message.visible = true

func _on_body_exited(body):
	if body.get_type() == "Player":
		message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
