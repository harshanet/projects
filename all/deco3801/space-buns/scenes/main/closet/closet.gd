extends Area2D
var opened = false
@export var item : Area2D
var contained_item = null
# Called when the node enters the scene tree for the first time.
func _ready():
	if item != null:
		item.set_collision_layer_value(8, false)
		item.set_collision_mask_value(2, false)
		contained_item = item
	$Open.visible = false
	z_index = 25	


@rpc("any_peer", "call_local")
func open():
	if (opened == false):
		$Open.visible = true
		$Close.visible = false
		z_index = 0
		if contained_item != null:
			contained_item.set_collision_layer_value(8, true)
			contained_item.set_collision_mask_value(2, true)


func get_type():
	return "Closet"
