extends Node2D

signal room_update

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setup notifications for any listeners so that they are aware of what players (by id)
	# enter what room (by name)
	for room in get_children():
		room.area_entered.connect(func(area): room_update.emit(room.name, area.player))
