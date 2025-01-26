extends Node

var world
var winner = null
var Players = {}
var votes_count = {}
var votes = {}
var eliminated_players = []
var NUM_PLAYERS
var voted = false
var wanted_id 
func voting_concluded(id):
	NUM_PLAYERS = Players.keys().size()
	var votes_num = votes_count[id]
	var votes_num_array = votes_count.values()
	var remaining_votes = NUM_PLAYERS - votes_num_array.reduce(sum, 0)
	votes_num_array.erase(votes_num)
	var second_most_votes = votes_num_array.max()
	if (votes_num > second_most_votes + remaining_votes):
		return true
	else: 
		return false

func sum(accum, number):
	return accum + number
# Called when the node enters the scene tree for the first time.

func register_world(scene):
	world = scene


signal player_status_change
signal impostor_invisible

var PlayerStatuses = {}

func player_ack(id, player):
	PlayerStatuses[id] = {'hungry': false, 'injured': false}
	player.status_changed.connect(func(property, next): receive_player_update(id, property, next))

func receive_player_update(id, property, next):
	print("Player ", str(id), " property ", property, " updated")
	PlayerStatuses[id][property] = next
	player_status_change.emit()

func is_hunrgy(id):
	return PlayerStatuses[id]['hungry']
	
func is_injured(id):
	return PlayerStatuses[id]['injured']
	
func all_injured():
	for id in PlayerStatuses.keys():
		if id == impostor_id:
			continue
		if not is_injured(id):
			return false
			
	return true

func any_injured():
	for id in PlayerStatuses.keys():
		if id == impostor_id:
			continue
		if is_injured(id):
			return true
	
	return false
	
var impostor_id

func impostor_ack(id, invisible_signal):
	impostor_id = id
	invisible_signal.connect(func(invisible): impostor_invisible.emit(invisible))

var completed = false

@rpc("any_peer", "call_remote")
func complete_game(who_won):
	if completed:
		return
	winner = who_won
	completed = true
	var scene = load("res://end_screen.tscn").instantiate()
	add_child(scene)
	
	UILayer.hide()
	world.hide()
