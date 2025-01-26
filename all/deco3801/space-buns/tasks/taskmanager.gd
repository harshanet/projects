extends Node2D

signal updated
signal hazards_updated
signal hazard_created

# Task manager keeps track of tasks and hazards and keeps their statuses in sync
# Across all clients

var statuses = {}
var infos = {}

var hazards = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # spawn all tasks

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialise(scene: Node): # Load all the tasks and initialise them within the given scene
	var tasks = scene.Tasks
	
	for task in tasks.get_children():
		initialise_task(task)

func initialise_task(task: Task): # Initialise a single task
	task.task_init()
	
	infos[task.task_name] = task.info # Keep track of the task info resource
	statuses[task.task_name] = 0 # Set the tasks current checkpoint number to 0 (started)

	task.task_progressed.connect(_receive_task_update) # Listen for task update notifications
	
func _receive_task_update(name: String):
	statuses[name] += 1
	
	if is_complete(name):
		pass # Task Complete
		
	updated.emit() # Let any listeners know that some task has updated its status

func get_checkpoint(name: String): # Return the current checkpoint number for a task
	return statuses[name]
	
func get_info(name: String): # Return the info resoruce for a task
	return infos[name]

func is_complete(name: String): # Return true iff the given task is complete
	return statuses[name] == infos[name].checkpoints
	
func get_tasks(): # Get all tasks
	return infos.keys()
	
func register_hazard(name: String): # Register a hazard and keep track of it
	if hazards.has(name) and hazards[name] != 0:
		hazards[name] += 1
		hazards_updated.emit()
	else:
		hazards[name] = 1
		hazard_created.emit(name)
		hazards_updated.emit()


func hazard_status(name: String): # Get a hazard's current status
	return hazards[name]

func remove_hazard(name: String): # Decrement a hazard's status by 1 and notify everyone
	hazards[name] -= 1
	if hazards[name] < 0:
		hazards[name] = 0
	hazards_updated.emit()

func hazard_mitigated(name: String): # Return true iff the hazard no longer exists
	return hazards[name] == 0

func get_hazards(): # Get a list of all hazards
	return hazards.keys()

func all_complete(): # Return true iff there are no tasks remaining and all hazards are mitigated
	for hazard in get_hazards():
		if not hazard_mitigated(hazard):
			return false
			
	for task in get_tasks():
		if not is_complete(task):
			return false
			
	return true
