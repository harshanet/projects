extends Node2D
class_name Task

@export var info: TaskInfo

signal task_progressed

var task_name

# An abstract class representing a task, it automatically keeps other clients in sync with
# the task's progress and any client can query the shared status of a task

func task_init():
	task_name = info.name

func progress_task(): # Progress the task forward on all machines
	task_progressed.emit(task_name)
	#notify_peers.rpc()

@rpc("any_peer", "call_remote")
func notify_peers(): # Let peers know the task has updated
	task_progressed.emit(task_name)

func get_checkpoint(): # Query the shared task status
	return TaskManager.get_checkpoint(task_name)
