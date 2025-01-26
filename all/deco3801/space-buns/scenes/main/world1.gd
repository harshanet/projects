extends Node2D

@export var PlayerScene : PackedScene
@export var ImposterScene : PackedScene

@onready var Tasks = $Tasks

var imposter_index
# Called when the node enters the scene tree for the first time.
func _ready():
	var players_color = ["res://entities/player/resources/normal/blue.tres",
	 "res://entities/player/resources/normal/green.tres",
	 "res://entities/player/resources/normal/orange.tres",
	 "res://entities/player/resources/normal/red.tres",
	 "res://entities/player/resources/normal/white.tres",
	 "res://entities/player/resources/normal/yellow.tres"]
	var sprite_frames_array = []
	var index = 0
	for i in GameManager.Players:
		var currentPlayer 
		if index != imposter_index:
			currentPlayer = PlayerScene.instantiate()
		else:
			currentPlayer = ImposterScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i])
		GameManager.votes_count[str(GameManager.Players[i])] = 0
		var sprite_frames = load(players_color[index])
		currentPlayer.get_node("SpaceOutfit").set_sprite_frames(sprite_frames)
		add_child(currentPlayer)
		for spawn in get_tree().get_nodes_in_group("SpawnLocations"):
			if spawn.name == str(index):
				currentPlayer.global_position = spawn.global_position
		index += 1
		
func get_type():
	return "World1"
