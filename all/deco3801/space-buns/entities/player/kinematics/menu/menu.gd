extends Control

@export var powerups: Array[MovementData]

signal item_selected(data: MovementData)

# Called when the node enters the scene tree for the first time.
func _ready():
	var index = 0
	
	for button in get_children():
		button.pressed.connect(func (): propagate(index))
		index += 1
		
func propagate(id: int):
	item_selected.emit(powerups[id])
