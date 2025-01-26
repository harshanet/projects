extends Button

@export var item : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(choose_item)

func choose_item():
	if (item != null):
		$"../..".propagate(item)
		
