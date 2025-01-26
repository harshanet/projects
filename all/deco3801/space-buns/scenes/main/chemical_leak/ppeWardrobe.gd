extends Area2D

var items = {"head" : "medical_mask", "torso" : "lab_coat"} #kinda want to add gloves and glasses
var closed = true
	
@rpc("any_peer", "call_local")
func open():
	closed = false
	$AnimatedSprite2D.animation = "open"
	$CoatSprite.show()
	$MaskSprite.show()

func get_type():
	return "Wardrobe"

func get_status():
	return closed
