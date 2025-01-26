extends Task

@onready var plants = $Plants
@onready var VeggiesFridge = $VeggiesFridge

var plants_harvested = false
var seeds_planted = false
var seeds_sprayed = false
var plants_in_fridge = false

func task_init():
	super()
	# Do task initialisation stuff
	
func progress_task():
	super()

@rpc("any_peer", "call_local")
func change_plants_harvested(status):
	plants_harvested = status

@rpc("any_peer", "call_local")
func change_seeds_planted(status):
	seeds_planted = status

@rpc("any_peer", "call_local")
func change_seeds_sprayed(status):
	seeds_sprayed = status

@rpc("any_peer", "call_local")
func change_plants_in_fridge(status):
	plants_in_fridge = status

func _process(delta):
	# progresses the task only if the player is up to that checkpoint and have 
	# completed the appropriate actions for the next checkpoint
	match (get_checkpoint()):
		0: 
			if (plants_harvested) and (not seeds_planted) and (not seeds_sprayed) and (not plants_in_fridge):
				progress_task()
				print("Progressed: plants harvested")
		1: 
			if (plants_harvested) and (not seeds_planted) and (not seeds_sprayed) and (plants_in_fridge):
				progress_task()
				print("Progressed: plants in fridge")
		2:
			if (plants_harvested) and (seeds_planted) and (not seeds_sprayed) and (plants_in_fridge):
				progress_task()
				print("Progressed: seeds planted")
		3:
			if (plants_harvested) and (seeds_planted) and (seeds_sprayed) and (plants_in_fridge):
				print("Finished: seeds watered")
				progress_task()

func get_type():
	return "HarvestPlants"
