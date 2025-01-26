extends Resource
class_name TaskInfo

# A resrouce representing the various information associated with the task

@export var name: String # A friendly name for the task
@export var location: String # Where the task takes place
@export var checkpoints: int # The number of stages to the task
@export var helptexts: PackedStringArray # Hints for the task
