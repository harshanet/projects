extends Control

@export var ServerAddress = "0.0.0.0"

@export var Port = 25565

const SHARED_SCREEN = preload("res://scenes/shared/shared.tscn")
const ROOM_BOUNDS = preload("res://scenes/shared/rooms.tscn")

var peer
# Called when the node enters the scene tree for the first time.

#Set up multiplayer
func _ready():
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.allow_object_decoding = true
	if "--server" in OS.get_cmdline_args(): # Run server when launched from command line
		host_game()

func connected_to_server():
	print("Connected to server!")
	send_player_information.rpc_id(1, multiplayer.get_unique_id())
	
func connection_failed():
	print("Connection failed!")

func player_connected(id):
	print("Player connected " + str(id))

func player_disconnected(id):
	print("Player disconnected " + str(id))


@rpc("any_peer", "call_local")
func start_game(imposter_index):
	var scene = load("res://scenes/main/world.tscn").instantiate()
	scene.imposter_index = imposter_index	
	get_tree().root.add_child(scene)
	self.hide()
	
	# Setup and initialise Singleton managers
	GameManager.register_world(scene)
	UILayer.layer = 1
	TaskManager.initialise(scene)
	
	if multiplayer.is_server():
		var shared_screen = SHARED_SCREEN.instantiate()
		var rooms = ROOM_BOUNDS.instantiate()
		shared_screen.initialise(scene, rooms) # Let the shared screen know about the room colliders (for minimap)
		
		scene.add_child(rooms)
		scene.hide()
		
		get_tree().root.add_child(shared_screen)

@rpc("any_peer")
func send_player_information(id):
	# Propogate all currently connected clients whenever a new client connects
	if !GameManager.Players.has(id):
		GameManager.Players[id] = id
	if multiplayer.is_server():
		for i in GameManager.Players:
			send_player_information.rpc(GameManager.Players[i])

func host_game():
	# Create a new Server with reasonable defaults
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(Port, 6)
	if error != OK:
		print("Cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players...")

func _on_host_button_down():
	host_game()
	#send_player_information(multiplayer.get_unique_id())
	$Host.disabled = true
	$Host.visible = false
	$Join.disabled = true
	$Join.visible = false
	$StartGame.disabled = false
	$StartGame.visible = true
	
	var ip_address = "127.0.0.1" # Default local loopback IP
	
	# Attempt to find the bound IPv4 address depending on host system
	if OS.has_feature("windows"):
		if OS.has_environment("COMPUTERNAME"):
			ip_address =  IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	elif OS.has_feature("x11"):
		if OS.has_environment("HOSTNAME"):
			ip_address =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	elif OS.has_feature("OSX"):
		if OS.has_environment("HOSTNAME"):
			ip_address =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	
	# Show the guessed IP in the text box when hosting
	$LineEdit.text = ip_address
	$LineEdit.editable = false


func _on_join_button_down():
	# Connect to the server with the IP specified in the text box
	peer = ENetMultiplayerPeer.new()
	
	peer.create_client($LineEdit.text, Port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	$Host.disabled = true
	$Host.visible = false
	$Join.disabled = true
	$Join.visible = false
	$WaitingIcon.visible = true

func _on_start_game_button_down():
	var imposter_index = 1 % GameManager.Players.size()
	rpc("start_game", imposter_index)
	# RPC start game on every client and pick an impostor
