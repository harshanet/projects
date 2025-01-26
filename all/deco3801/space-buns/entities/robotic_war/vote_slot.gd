extends TouchScreenButton
var disabled = false
var player_id
# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(submit_vote)

func submit_vote():
	$"../..".propagate(player_id)

func _process(delta):
	if GameManager.eliminated_players.has(player_id) and disabled == false:
		self.modulate.a = 0.5 
		disabled = true
		self.pressed.disconnect(submit_vote)
