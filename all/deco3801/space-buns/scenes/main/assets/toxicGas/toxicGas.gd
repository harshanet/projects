extends Area2D

var sprayedTime = 0
var expansion_time = 0
var has_spread = false
var self_path = "res://scenes/main/assets/toxicGas/toxicGas.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	TaskManager.register_hazard("Toxic Gas")

@rpc("any_peer", "call_local")
func delete():
	TaskManager.remove_hazard("Toxic Gas")
	self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if expansion_time > 600 and has_spread == false:
		#spread_gas()
		has_spread = true
	elif has_spread == false:
		expansion_time += 1
		
@rpc("any_peer", "call_local")
func spread_gas():
	var item = load(self_path).instantiate()
	add_child(item)
	item.global_position = $Node2D.global_position
		
func _on_area_entered(area):
	if (area.get_type() == "DisinfectantGas"):
		delete.rpc()

func get_type():
	return "ToxicGas"

func _on_body_entered(body):
	# if a player enters the gas' collision area, and they are not wearing 
	# appropriate ppe, then injur them
	if body.has_method("get_type") and (body.get_type() == "Player"):
		var injure = true
		if ((body.clothes["head"] != null and body.clothes["head"].get_type() == "MedicalMask") 
		and (body.clothes["torso"] != null and body.clothes["torso"].get_type() == "LabCoat")):
			injure = false
		if injure:
			if (body.injured == false):
				body.injured = true
				body.inflict_injury("COPoison")
