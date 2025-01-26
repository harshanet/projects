extends Node2D

@onready var camera = $Camera2D
@onready var labels = $Labels

@onready var cover = $MapCover

@onready var unpositioned = $Unpositioned

var ICON_SCENE = preload("res://scenes/shared/minimap_icon.tscn")
var TASK_SCENE = preload("res://scenes/shared/task_display.tscn")
var HAZARD_SCENE = preload("res://scenes/shared/hazard_display.tscn")

var targets = {} # Stores a mapping of room names to positions in the shared scene for player icons to go
var players = {} # Stores a mapping of player ids to player icon instances

# Called when the node enters the scene tree for the first time.
func _ready():
	const icons = [
		"res://scenes/shared/assets/icons/baz.png",
		"res://scenes/shared/assets/icons/harsha.png",
		"res://scenes/shared/assets/icons/phillip.png",
		"res://scenes/shared/assets/icons/victor.png",
		"res://scenes/shared/assets/icons/rio.png",
		"res://scenes/shared/assets/icons/neha.png"
	]
	var index = 0
	
	for i in GameManager.Players: # For each player...
		var icon = ICON_SCENE.instantiate()
		
		icon.name = str(GameManager.Players[i])
		icon.texture = load(icons[index])
		
		players[str(GameManager.Players[i])] = icon
		unpositioned.add_child(icon) # Load their respective icon and put it in an unknown position for now
		
		index += 1
		
	for label in labels.get_children():
		targets[label.name] = label.get_child(0) # Get a reference to every room's label and map it to the room name
		
	camera.make_current() # Focus on the shared screen
	
	# Connect signals to update shared screen whenever a game event occurs
	GameManager.impostor_invisible.connect(cover_map)
	TaskManager.hazard_created.connect(draw_hazard)
	
	# Whenever a task or hazard is updated, or a player changes injury status, check for game over
	TaskManager.updated.connect(check_game_over)
	TaskManager.hazards_updated.connect(check_game_over)
	GameManager.player_status_change.connect(check_game_over)
	
	$TimedProgress.timeout.connect(impostor_victory) # If the timer runs out the impostor wins by default
	
		
func initialise(world, rooms):
	rooms.room_update.connect(redraw)
	
	for task in TaskManager.get_tasks(): # Draw the list of tasks
		var display = TASK_SCENE.instantiate()
		display.initialise(task)

		TaskManager.updated.connect(display.redraw) # Connect the task text to the corresponding task's updates
		$Tasks/BarWindow/VBoxContainer.add_child(display)

func redraw(room, player): # Move a player icon from its old position to its new room
	var target = targets[room]
	players[player].reparent(target, false)

func draw_hazard(hazard: String): # Draw a hazard (when one is added to the tracked hazards)
	var display = HAZARD_SCENE.instantiate()
	display.initialise(hazard)
	
	TaskManager.hazards_updated.connect(display.redraw) # Connect the hazard text to the corresponding hazard's updates
	$Tasks/BarWindow/VBoxContainer.add_child(display)
	
func cover_map(invisible_status): # Cover the map with static when the impostor goes invisible
	if invisible_status:
		cover.show()
	else:
		cover.hide()
		
func check_game_over(): # Check for game over
	if not GameManager.any_injured() and TaskManager.all_complete():
		# If no crewmates are injured and there are no tasks or hazards remaining, crewmates win
		crewmate_victory()
	elif GameManager.all_injured():
		# If every crewmate is injured, the impostor instantly wins
		impostor_victory()

func crewmate_victory():
	print("CREWMATES WIN!!!!!")
	GameManager.complete_game.rpc("crewmates") # Transition all clients to the quiz with the corresponding victory text

func impostor_victory():
	print("IMPOSTORS WIN!!!!!")
	GameManager.complete_game.rpc("imposter") # Transition all clients to the quiz with the corresponding victory text

