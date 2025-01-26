extends CanvasModulate

@export var visibility : bool
# Called when the node enters the scene tree for the first time.
func _ready():
	if visibility:
		show()
