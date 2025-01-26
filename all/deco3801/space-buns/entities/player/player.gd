class_name Player
extends CharacterBody2D

signal status_changed

#Enums for player's states
enum { MOVE, CLIMB, INTERACT }

#Constants - including scenes to be instantiated
const LADDER_LAYER = 5
const MEDICAL_MENU = preload("res://entities/medical_inventory/medical_inventory.tscn")
const VOTING_SCREEN = preload("res://entities/robotic_war/voting_screen.tscn")
const MECHANICAL_MENU = preload("res://sci-fi_fix_task/mechanical_parts.tscn")
# clothing dictionary for wardrobe access
var clothes = {"head" : null, "eyes" : null, "torso" : null, 
	"legs" : null, "feet" : null, "hands" : null}

# for keeping track of when a full button press has occurred (interact and use)
var interact_pressed = false
var full_interact_pressed = false
var activate_pressed = false
var full_activate_pressed = false

# For interactable screens such as medical menu and voting screen
var medical_menu
var voting_screen
var mechanical_menu

#onready variables
@onready var kinematics = $KinematicsManager
@onready var finite_state_machine = $FiniteStateMachine as FiniteStateMachine
@onready var injured_state = $FiniteStateMachine/InjuredState as InjuredState
@onready var animated_sprite = $SpaceOutfit
@onready var ladder_check = $LadderCheck
@onready var interact_button = $InteractButton
@onready var activate_button = $ActivateButton
#Player's prorperties
var state = CLIMB
var pickedItem = null
var picked = false
var injured = false
var pickableSceneToCreate = null
var ppe_worn = false
var hit_times = 0
var picked_item_path 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Variables for synchronization purposes
var syncPos = Vector2.ZERO
var syncPickedItemPosition = Vector2.ZERO
var syncItemEffectRotation = 0
var syncItemFlip = false


#Preprocessing necessary procedures to allow synchronization
func _ready():
	GameManager.player_ack(str(name), self)
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		$PPEOutfit.hide()
		$Camera2D.make_current()
		injured_state.cured.connect(player_cured_handle)
		activate_button.pressed.connect(activate_pickable)
	else:
		$PointLight2D.visible = false
		interact_button.queue_free()
		activate_button.queue_free()
		$InformationButton.queue_free()
		$ExitInfoButton.queue_free()
	kinematics.interaction_begin.connect(_on_kinematics_interaction_begin)
	kinematics.interaction_end.connect(_on_kinematics_interaction_end)

# Activate the item hold on hand
func activate_pickable():
	if (pickedItem != null) and (pickedItem.has_method("activate")):
		pickedItem.activate.rpc()

# Apply the gravity to the player
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

#Handle the acceleration of the player's speed
func handle_acceleration(direction, delta):
	if direction.x:
		if sign(direction.x) == sign(velocity.x) or velocity.x == 0:
			velocity.x = move_toward(velocity.x, kinematics.speed * direction.x, kinematics.acceleration * delta)
		else:
			velocity.x = 0
	else:
		velocity.x = 0

#Update the player's animations based on current actions
@rpc("any_peer", "call_local")
func update_animation(direction):
	match state:
		MOVE:
			if direction.x:
				animated_sprite.flip_h = (direction.x < 0)
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")
		CLIMB:
			if is_on_floor():
				animated_sprite.play("idle")
			elif direction.y:
				animated_sprite.play("climb")
			else:
				animated_sprite.pause()
	for clothing_item in clothes.keys():
		if (clothes[clothing_item] != null) and (typeof(clothes[clothing_item]) != TYPE_STRING):
			match state:
				MOVE:
					clothes[clothing_item].show()
					if direction.x:
						if direction.x < 0:
							clothes[clothing_item].face_left()
						else:
							clothes[clothing_item].face_right()
					else:
						clothes[clothing_item].face_neutral()
				CLIMB:
					if is_on_floor():
						clothes[clothing_item].face_neutral()
					else:
						if clothes[clothing_item].has_method("climb_animation"):
							if direction.y:
								clothes[clothing_item].play("climb")
							else:
								clothes[clothing_item].pause()
						else:
							clothes[clothing_item].hide()

func _physics_process(delta):
	if interact_pressed and (not interact_button.is_pressed()):
		full_interact_pressed = true
		interact_pressed = false
	else:
		full_interact_pressed = false
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		var direction = Vector2.ZERO
		direction.x = Input.get_axis("ui_left", "ui_right")
		direction.y = Input.get_axis("ui_up", "ui_down")
		# Handle location of the picked item based on player direction
		if (pickedItem != null) and (is_ancestor_of(pickedItem)):
			if (direction.x > 0):
				$PickUpItemPositionRotation.rotation_degrees = 0
				syncItemFlip = false
				pickedItem.get_node("EffectRotation").rotation_degrees = 0
				if pickedItem.has_node("Sprite2D") == false:
					pickedItem.get_node("AnimatedSprite2D").flip_h = false
				else:
					pickedItem.get_node("Sprite2D").flip_h = false
				syncItemEffectRotation = 0
			elif (direction.x < 0):
				syncItemFlip = true
				$PickUpItemPositionRotation.rotation_degrees = -180
				pickedItem.get_node("EffectRotation").rotation_degrees = -180
				if pickedItem.has_node("Sprite2D") == false:
					pickedItem.get_node("AnimatedSprite2D").flip_h = true
				else:
					pickedItem.get_node("Sprite2D").flip_h = true
				syncItemEffectRotation = -180
			else:
				if (Input.is_action_just_pressed("ui_right")):
					syncItemFlip = false 
					$PickUpItemPositionRotation.rotation_degrees = 0
					pickedItem.get_node("EffectRotation").rotation_degrees = 0
					if pickedItem.has_node("Sprite2D") == false:
						pickedItem.get_node("AnimatedSprite2D").flip_h = false
					else:
						pickedItem.get_node("Sprite2D").flip_h = false
					syncItemEffectRotation = 0
				elif (Input.is_action_just_pressed("ui_left")):
					syncItemFlip = true
					$PickUpItemPositionRotation.rotation_degrees = -180
					pickedItem.get_node("EffectRotation").rotation_degrees = -180
					if pickedItem.has_node("Sprite2D") == false:
						pickedItem.get_node("AnimatedSprite2D").flip_h = true
					else:
						pickedItem.get_node("Sprite2D").flip_h = true
					syncItemEffectRotation = -180
			pickedItem.global_position = $PickUpItemPositionRotation/PickUpItemPosition.global_position
			syncPickedItemPosition = $PickUpItemPositionRotation/PickUpItemPosition.global_position
		# Specifying actions for different states of player
		match state:
			MOVE: move_state(delta, direction)
			CLIMB: climb_state(delta, direction)
			INTERACT: return
		
		var dont_pick = false
		# Allowing players to interact with different objects
		if $InteractableArea.has_overlapping_areas() and full_interact_pressed:
			var interactable = $InteractableArea.get_overlapping_areas()[0]
			match interactable.get_type():	
				"Wardrobe":
					if not ppe_worn: 
						if interactable.get_status() == true:
							interactable.open.rpc()
						else:
							for item in interactable.items.keys():
								if (clothes[item] == null) or (clothes[item].get_clothing_name() != interactable.items[item]):
									var clothes_scene_path = "res://entities/clothes/" + interactable.items[item] + ".tscn"
									var type = item
									rpc("put_clothing_item_on", clothes_scene_path, type)
									break
				"ToxicBin": 
					if (pickedItem != null) and (pickedItem.get_type() == "Mop"):
						dont_pick = true
						throw_item.rpc()
					else:
						if animated_sprite == $PPEOutfit:
							$PPEOutfit.hide()
							$SpaceOutfit.show()
							animated_sprite = $SpaceOutfit
							ppe_worn = false
							$FiniteStateMachine/InjuredState.animator = $SpaceOutfit
							kinematics.take_off_ppe()
						remove_clothes.rpc()
				"RoboticPoliceManager":
					if GameManager.voted == false:
						police_manager_interact()
				"Closet":
					interactable.open.rpc()
				"Fridge":
					$KinematicsManager.begin_interaction()
				"MedicalStorage":
					medical_inventory_interact(interactable)
				"MechanicalStorage":
					mechanical_inventory_interact()
				"PPESuit":
					animated_sprite = $PPEOutfit
					$PPEOutfit.show()
					$SpaceOutfit.hide()
					interactable.delete.rpc()
					ppe_worn = true
					$FiniteStateMachine/InjuredState.animator = $PPEOutfit
					kinematics.put_on_ppe()
					print("ppe worn")
				"PowerPoint":
					interactable.flick.rpc()
				"ElectricalMachine":
					interactable.flick.rpc()
				"Wire":
					if (interactable.power == true) and (interactable.wire_status == "bad"):
						pass
						# electricute player
						if injured == false and ppe_worn == false:
							injured = true
							inflict_injury("Electrocuted")
					elif (pickedItem != null) and (pickedItem.get_type() == "GoodWire"):
						interactable.change_status.rpc("good")
						throw_item.rpc()
						dont_pick = true
					else:
						pass
				"VeggiesFridge":
					if picked and (pickedItem.get_type() == "HarvestTool"):
						interactable.give_plants()
						if interactable.recieved_plants():
							throw_item.rpc()
					dont_pick = true
				"BatteryProducer":
					if interactable.processing == false:
						interactable.start_processing.rpc()
						interactable.activate.rpc()
				"ChemicalProducer":
					if interactable.processing == false:
						interactable.start_processing.rpc()
						interactable.activate.rpc()
		#Allowing players to pick up pickable items
		if not dont_pick:
			if not picked: #player is not currently holding an item
				if $PickUpArea.has_overlapping_areas():
					var pickableItem = $PickUpArea.get_overlapping_areas()[0]
					if (pickableItem) and (full_interact_pressed) and not pickableItem.is_picked():
						rpc("pick_item")
			else: #we are currently holding an item
					if full_interact_pressed:
						rpc("drop_item")
						picked_item_path = null
						
		dont_pick = false
		syncPos = global_position
		rpc("update_animation", direction)
		move_and_slide()
	else:
		#Handling synchronizations across all machines
		global_position = global_position.lerp(syncPos, .5)
		if (pickedItem != null) and (is_ancestor_of(pickedItem)):
			pickedItem.global_position = pickedItem.global_position.lerp(syncPickedItemPosition, .5)
			pickedItem.get_node("EffectRotation").rotation_degrees = lerpf(pickedItem.get_node("EffectRotation").rotation_degrees, syncItemEffectRotation, .5)
			if pickedItem.has_node("Sprite2D") == false:
				pickedItem.get_node("AnimatedSprite2D").flip_h = syncItemFlip
			else:
				pickedItem.get_node("Sprite2D").flip_h = syncItemFlip

#Functions below are used for handling wearing lab clothes 
@rpc("any_peer", "call_local")
func put_clothing_item_on(clothes_scene_path, clothing_type):
	var new_clothes = load(clothes_scene_path).instantiate()
	add_child(new_clothes)
	match clothing_type:
		"head": new_clothes.global_position = $ClothingHead.global_position
		"torso": new_clothes.global_position = $ClothingTorso.global_position
	clothes[clothing_type] = new_clothes

@rpc("any_peer", "call_local")
func remove_clothes():
	for clothing_item in clothes.keys():
		if clothes[clothing_item] != null:
			clothes[clothing_item].delete()
	clothes = {"head" : null, "eyes" : null, "torso" : null, 
	"legs" : null, "feet" : null, "hands" : null}

# Handling the moving state of the player
func move_state(delta, direction):
	if is_on_ladder() and direction.y:
		set_collision_mask_value(LADDER_LAYER, false)
		state = CLIMB
	apply_gravity(delta)
	handle_acceleration(direction, delta)

# Handling the climbing state of the player
func climb_state(delta, direction):
	if not is_on_ladder():
		set_collision_mask_value(LADDER_LAYER, true)
		state = MOVE
	velocity = direction * kinematics.speed
	pass

func is_on_ladder():
	return ladder_check.is_colliding()

func _on_interact_button_pressed():
	interact_pressed = true

# Return player type for specific operations
func get_type():
	return "Player"

#Functions below are used for handling pickable items
@rpc("any_peer", "call_local")
func throw_item():
	if (pickedItem != null):
		pickedItem.delete()
		pickedItem = null
		picked = false

@rpc("any_peer", "call_local")
func drop_item():
	if picked:
		pickedItem.picked = false
		pickedItem.message.visible = true
		pickedItem.message_removed = false
		pickedItem.global_position = global_position
		pickedItem.reparent(get_parent())
		pickedItem = null
		picked = false


@rpc("any_peer", "call_local")
func pick_item():
	if not picked and $PickUpArea.has_overlapping_areas():
		var item = $PickUpArea.get_overlapping_areas()[0]
		item.reparent(self)
		item.picked = true
		if item.has_method("remove_message"):
			item.remove_message()
		item.global_position = $PickUpItemPositionRotation/PickUpItemPosition.global_position
		picked = true
		pickedItem = item
	
#Two functions below are used for transitioning to injury state and back
func inflict_injury(injury):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		injured_state.set_injury.rpc(injury)
		throw_item.rpc()
		await get_tree().create_timer(0.2).timeout
		if medical_menu != null:
			medical_menu.queue_free()
		finite_state_machine.change_state(injured_state)


func player_cured_handle():
	injured_state._exit_state.rpc()
	injured = false

#Two functions below are used for kinematics interaction
func _on_kinematics_interaction_begin():
	state = INTERACT
	
func _on_kinematics_interaction_end():
	state = MOVE

#Functions below are used to interact with medical inventory
func medical_inventory_interact(interactable):
	interactable.open()
	state = INTERACT
	medical_menu = UILayer.request_draw(MEDICAL_MENU, UI.Position.CENTER)
	medical_menu.item_selected.connect(end_medical_interaction.bind(interactable))
	medical_menu.exit.connect(exit_medical_inventory.bind(interactable))

func end_medical_interaction(scene: PackedScene, interactable):
	rpc("pick_item_with_scene", scene)
	medical_menu.queue_free()
	state = MOVE
	interactable.close()

@rpc("any_peer", "call_local")
func pick_item_with_scene(scene):
	var item = scene.instantiate()
	add_child(item)
	item.picked = true
	if item.has_method("remove_message"):
		item.remove_message()
	item.global_position = $PickUpItemPositionRotation/PickUpItemPosition.global_position
	picked = true
	pickedItem = item

func exit_medical_inventory(interactable):
	medical_menu.queue_free()
	state = MOVE
	interactable.close()

#Functions below are used to interact with mechanical inventory
func mechanical_inventory_interact():
	state = INTERACT
	mechanical_menu = UILayer.request_draw(MECHANICAL_MENU, UI.Position.CENTER)
	mechanical_menu.item_selected.connect(end_mechanical_interaction)
	mechanical_menu.exit.connect(exit_mechanical_inventory)

func end_mechanical_interaction(scene: PackedScene):
	rpc("pick_item_with_scene", scene)
	mechanical_menu.queue_free()
	state = MOVE

func exit_mechanical_inventory():
	mechanical_menu.queue_free()
	state = MOVE

#Functions below are used to interact with the voting system and its mechanics
func police_manager_interact():
	state = INTERACT
	voting_screen = UILayer.request_draw(VOTING_SCREEN, UI.Position.CENTER)
	voting_screen.player_voted.connect(end_voting_with_result)
	voting_screen.cancel_voting.connect(end_voting)

func end_voting_with_result(id: String):
	rpc("vote", id)
	if (GameManager.voting_concluded(id)):
		var police_manager = get_tree().get_first_node_in_group("PoliceManager")
		if police_manager.get_status() == false:
			police_manager.set_status(true)
			police_manager.rpc("activate", false)
	voting_screen.queue_free()
	state = MOVE

@rpc("any_peer", "call_local")
func vote(id: String):
	if GameManager.votes.has(self.name):
		GameManager.votes_count[GameManager.votes.get(self.name)] -= 1
		GameManager.votes[self.name] = id
	else:
		GameManager.votes[self.name] = id 
	GameManager.votes_count[id] += 1
	if (GameManager.voting_concluded(id)):
		GameManager.wanted_id = id
		GameManager.voted = true

func end_voting():
	voting_screen.queue_free()
	state = MOVE

@rpc("any_peer", "call_local")
func player_elimination_handle():
	status_changed.emit('injured', true)
	GameManager.wanted_id = null
	GameManager.voted = false
	GameManager.votes.clear()
	GameManager.eliminated_players.append(self.name)
	GameManager.votes_count.erase(self.name)
	GameManager.Players.erase(self.name)
	for key in GameManager.votes_count.keys():
		GameManager.votes_count[key] = 0
	set_collision_layer_value(13, false)
	get_tree().get_first_node_in_group("PoliceManager").set_status(false)
	Signals.DeactivateRobots.emit()
	self.queue_free()
	

func get_picked_item():
	if picked == false:
		return null
	return pickedItem
	
#Functions used to make player take damage from shots
func take_damage(damage = 1):
	hit_times += damage
	if (hit_times > 5):
		if GameManager.voted == true and self.name == GameManager.wanted_id:
			for player in get_tree().get_nodes_in_group("player"):
				player.get_node("PointLight2D").show()
			player_elimination_handle.rpc()
		else:
			inflict_injury("Burn")
		hit_times = 0

func _on_pick_up_area_body_entered(body):
	if body.get_collision_mask_value(2) == true and $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id() and body.get_type() != "WoodenStick":
		take_damage(2)

# Functions below are used to deal with the information book
func _on_information_button_pressed():
	$GameInfo.visible = true
	$ExitInfoButton.visible = true
	kinematics.interaction_begin.emit()


func _on_exit_info_button_pressed():
	$GameInfo.visible = false
	$ExitInfoButton.visible = false
	kinematics.interaction_end.emit()
