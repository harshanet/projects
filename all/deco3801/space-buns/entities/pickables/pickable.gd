class_name Pickable
extends Node
var picked = false
@rpc("any_peer", "call_local")
func delete():
	self.queue_free()

@rpc("any_peer", "call_local")
func activate():
	pass
	
func get_type():
	pass

func is_picked():
	return picked

