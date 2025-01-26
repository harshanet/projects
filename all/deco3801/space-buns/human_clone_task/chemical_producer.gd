extends Producer


# Called when the node enters the scene tree for the first time.
func _ready():
	initial_message = "Chemical Producer"
	super._ready()


func get_type():
	return "ChemicalProducer"
