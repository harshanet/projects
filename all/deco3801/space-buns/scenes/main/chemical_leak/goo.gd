extends Area2D

var mopTime = 0
var expansion_time = 0
var gas_time = 0
var self_path = "res://scenes/main/chemical_leak/goo.tscn"
var gas_path = "res://scenes/main/assets/toxicGas/toxicGas.tscn"
var has_spread = false
var gas_spreads = 0
var reached_door = false

# Called when the node enters the scene tree for the first time.
func _ready():
	TaskManager.register_hazard("Goo")

@rpc("any_peer", "call_local", "reliable")
func delete():
	TaskManager.remove_hazard("Goo")
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if TaskManager.hazard_status("Goo") >= 200:
		has_spread = true
	
	for thing in get_overlapping_areas():
		if (thing.get_type() == "Mop") and (thing.is_cleaning()):
			delete.rpc()
			# if the goo has expanded to a door, it should stop spreading 
		if thing.get_type() == "door":
			reached_door = true
	if expansion_time > 10:
		if not (has_spread or reached_door):
			spread_goo()
			expansion_time = 0
			has_spread = true
	elif has_spread == false:
		expansion_time += 1
	# the goo produces gas every 500 frames, only 3 times
	if (gas_time > 10):
		spread_gas()
		gas_time = 0
		gas_spreads += 1
	elif gas_spreads < 4:
		gas_time += 1
		
@rpc("any_peer", "call_local")
func spread_goo():
	var item = load(self_path).instantiate()
	add_sibling(item)
	item.global_position = $GooPos.global_position
	var item2 = load(self_path).instantiate()
	add_sibling(item2)
	item2.global_position = $GooPos2.global_position
	
@rpc("any_peer", "call_local")
func spread_gas():
	# the produced gas is added somewhere above the goo at a random height 
	var item = load(gas_path).instantiate()
	add_sibling(item)
	item.global_position = $GasPos.global_position
	item.global_position.y -= randi_range(0, 80)

func get_type():
	return "ToxicGoo"


func _on_body_entered(body):
	if body.has_method("get_type") and (body.get_type() == "Player"):
		var burn = true
		if ((body.clothes["head"] != null and body.clothes["head"].get_type() == "MedicalMask") 
		and (body.clothes["torso"] != null and body.clothes["torso"].get_type() == "LabCoat")):
			burn = false
		if burn:
			if (body.injured == false):
				body.injured = true
				body.inflict_injury("Burn")
