class_name MedicalItem
extends Pickable
var activated = false
var activatable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Sprite2D.set_texture(texture)
	pass

@rpc("any_peer", "call_local")
func activate():
	if activatable:
		activated = true

func is_activated():
	return activated
	
func get_type():
	pass

func _on_area_entered(area):
	activatable = true

func _on_area_exited(area):
	activatable = false

