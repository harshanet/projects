extends Task

@onready var wire = $wire
@onready var power_point = $power_point
@onready var machine = $electrical_machine

var power_on = true
var bad_wire = true
var machine_on = true
# different checkpoint meanings
# 0 = power on, wire bad, machine on
# 1 = power off, wire bad, machine on
# 2 = power off, wire bad, machine off
# 3 = power off, wire good, machine off
# 4 = power on, wire good, machine off
# 5 = power on, wire good, machine on

func task_init():
	super()
	# Do task initialisation stuff
	
func progress_task():
	super()
	# Handle updating of task checkpoints
	
@rpc("any_peer", "call_local")
func change_power_on(status):
	power_on = status

@rpc("any_peer", "call_local")
func change_wire_status(status):
	bad_wire = status

@rpc("any_peer", "call_local")
func change_machine_on(status):
	machine_on = status

# progresses the task only if the player is up to that checkpoint and have 
# completed the appropriate actions for the next checkpoint
func _process(delta):
	match (get_checkpoint()):
		0:
			if (power_on == false) and (bad_wire == true) and (machine_on == true):
				progress_task()
		1:
			if (power_on == false) and (bad_wire == true) and (machine_on == false):
				progress_task()
		2:
			if (power_on == false) and (bad_wire == false) and (machine_on == false):
				progress_task()
		3:
			if (power_on == true) and (bad_wire == false) and (machine_on == false):
				progress_task()
		4:
			if (power_on == true) and (bad_wire == false) and (machine_on == true):
				progress_task()
	wire.change_power.rpc(power_on)
	machine.set_power_status.rpc(power_on and (not bad_wire))
