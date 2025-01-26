extends Task

func task_init():
	super()
	# Do task initialisation stuff
	
func progress_task():
	super()
	# Handle updating of task checkpoints
	if multiplayer.is_server():
		print("server: ", task_name, " now at checkpoint ", get_checkpoint())
	else:
		print(task_name, "now at checkpoint", get_checkpoint())

func _ready():
	for insect in get_children():
		insect.killed.connect(progress_task)
