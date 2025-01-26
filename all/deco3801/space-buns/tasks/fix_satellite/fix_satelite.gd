extends Task

func task_init():
	super()
	# Do task initialisation stuff
	
func progress_task():
	super()
	# Handle updating of task checkpoints
	print(task_name, "now at checkpoint", get_checkpoint())

# Can use _ready, _process, and _physics_process if you need
func _ready():
	$ProbingSatelite.progress.connect(progress_task)
