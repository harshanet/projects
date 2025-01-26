extends Node2D

@export var DEFAULT_MOVEMENT_DATA: MovementData
@export var HUNGRY_MOVEMENT_DATA: MovementData
@export var PPE_MOVEMENT_DATA: MovementData

signal interaction_begin # Signal for when a UI menu is opened
signal interaction_end # Signal for when a UI menu is closed

signal hungry # Signal for when a player becomes hungry

var current # The currently loaded movement data
var instance

var t = 0 # The current time interpolation within a movement data

var speed = 0 # The current speed value of the connected player
var acceleration = 0 # The current acceleration value of the connected player

const INITIAL_HUNGER = 120 # Initial player hunger
const HUNGRY_THRESHOLD = 30 # The threshold for the hunger warning message to appear
const HUNGER_DECAY = 1 # The rate at which hunger decays per second

var hunger = INITIAL_HUNGER
var just_became_hungry = false
var just_became_starving = false

const FRIDGE_MENU = preload('menu/menu.tscn')

var fading_text = preload("res://entities/fading_text/fading_text.tscn")

func _ready():
	set_movement_data(DEFAULT_MOVEMENT_DATA)

func _process(delta):
	t += delta # Keep track of time
	hunger -= HUNGER_DECAY * delta # Decay player hunger
	
	if hunger <= 0:
		hunger = 0
		
		if not just_became_starving: # Show starving message when hunger is 0 (show it once)
			just_became_starving = true
			hungry.emit()
			set_movement_data(HUNGRY_MOVEMENT_DATA)
			
			
			var text = fading_text.instantiate()
			text.message = "I'm hungry... I should eat something"
			text.duration = 5
			
			add_child(text)
			text.global_position.y -= 20
			text.fade()
			
	if hunger <= HUNGRY_THRESHOLD: # Show hungry warning message when hunger below threshold
		if not just_became_hungry:
			just_became_hungry = true
			
			var text = fading_text.instantiate()
			text.message = "I'm feeling a little hungry"
			text.duration = 3
			
			add_child(text)
			
			text.global_position.y -= 20
			text.fade()
	
	if t > current.DURATION: # If the movement data duration has expired go back to default move speed (powerup ended)
		set_movement_data(DEFAULT_MOVEMENT_DATA)
		
	speed = current.sample(t) # Sample the speed from the movement data curve
	
func begin_interaction(): # Open the fridge and signal interaction begin
	if hunger >= 100: # If the player has eaten too recently then don't allow them to eat and warn them instead
		var text = fading_text.instantiate()
		text.message = "I'm too full to eat!"
		text.duration = 3
		add_child(text)
		text.global_position.y -= 20
		text.fade()
	else: # Otherwise draw the fridge menu and wait for a food to be picked
		interaction_begin.emit()
		instance = UILayer.request_draw(FRIDGE_MENU, UI.Position.CENTER)
		instance.item_selected.connect(end_interaction)
	
func end_interaction(data: MovementData): # Set the movement data to the picked one from the corresponding fridge item
	set_movement_data(data)
	hunger = INITIAL_HUNGER
	just_became_hungry = false
	just_became_starving = false
	instance.queue_free()
	interaction_end.emit()

func set_movement_data(data: MovementData):
	current = data
	
	acceleration = data.ACCELERATION
	speed = current.sample(0)
	
	t = 0 # Reset time counter

var prev_data # Remember previous movement data when putting on ppe gear
var prev_t # Remember previous time interpolation data when putting on ppe gear

func put_on_ppe(): # Change player movement data to the slow PPE settings and save previous data
	prev_t = t
	prev_data = current
	set_movement_data(PPE_MOVEMENT_DATA)

func take_off_ppe(): # Remove PPE gear data and revert to previously used movement data
	set_movement_data(prev_data)
	t = prev_t
