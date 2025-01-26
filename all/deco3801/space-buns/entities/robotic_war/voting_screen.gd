extends Control

signal player_voted(id:  String)
signal cancel_voting

func _ready():
	var index = 0
	var buttons = $GridContainer.get_children()
	for i in GameManager.Players:
		buttons[index].player_id = str(GameManager.Players[i])
		index += 1

func propagate(id: String):
	player_voted.emit(id)

func cancel():
	cancel_voting.emit()
