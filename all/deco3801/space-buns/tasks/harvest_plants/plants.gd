extends Area2D

var plant_status = "grown"
var harvestTime = 0
var plantSeedTime = 0
var watered = false
@export var harvested: Texture2D
@export var planted: Texture2D
@export var grown: Texture2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for thing in get_overlapping_areas():
		if (thing.get_type() == "HarvestTool") and (thing.is_harvesting()):
			harvestTime += 1
		elif (thing.get_type() == "SeedsBag") and (thing.is_planting()):
			plantSeedTime += 1
		elif (plant_status == "planted") and (thing.get_type() == "WaterMist"):
			watered = true
			get_parent().change_seeds_sprayed.rpc(true)
		if (plant_status == "grown") and (harvestTime > 300):
			plant_status = "harvested"
			harvestTime = 0
			plantSeedTime = 0
			update_texture.rpc()
			get_parent().change_plants_harvested.rpc(true)
		elif (plant_status == "harvested") and (plantSeedTime > 300):
			plant_status = "planted"
			harvestTime = 0
			plantSeedTime = 0
			watered = false
			get_parent().change_seeds_planted.rpc(true)
			update_texture.rpc()
			thing.remove()
		

@rpc("any_peer", "call_local")
func update_texture():
	if get_parent().plants_harvested:
		if get_parent().seeds_planted:
			$Sprite2D.texture = planted
		else:
			$Sprite2D.texture = harvested
	else:
		$Sprite2D.texture = grown

func get_status():
	return plant_status

