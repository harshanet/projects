extends Area2D

var has_plants = false

func delete():
	self.queue_free()

func recieved_plants():
	return has_plants

func give_plants():
	if (get_parent().get_type() == "HarvestPlants") and (get_parent().plants_harvested == true):
		has_plants = true
		get_parent().change_plants_in_fridge.rpc(true)

func get_type():
	return "VeggiesFridge"
