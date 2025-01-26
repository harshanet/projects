extends Player

signal invisible

@onready var invisible_button = $Invisible
@onready var invisible_countdown = $Invisible/InvisibleCountdown
@onready var invisible_duration = $Invisible/InvisibleDuration
@onready var explosive_countdown = $Sabotage/ExplosiveCooldown
@onready var sabotage_button = $Sabotage
@onready var alien_release_button = $AlienRelease
@onready var alien_cooldown = $AlienRelease/AlienReleaseCooldown
var alien_scene = preload("res://entities/enemy_alien/alien.tscn")
var explosive = preload("res://entities/player/explosive_device.tscn")
func _ready():
	super._ready()
	GameManager.impostor_ack(str(name), invisible)
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		invisible_button.pressed.connect(handle_invisible)
		sabotage_button.pressed.connect(place_explosive)
		alien_release_button.pressed.connect(release_monster)
	else:
		invisible_button.queue_free()
		sabotage_button.queue_free()
		alien_release_button.queue_free()
		

func release_monster():
	if alien_cooldown.is_stopped() and state != CLIMB:
		alien_cooldown.start()
		alien_release_button.modulate.a = 0.5
		spawn_alien.rpc()
	else:
		return

@rpc("any_peer", "call_local")
func spawn_alien():
	var alien = alien_scene.instantiate()
	get_parent().add_child(alien)
	alien.global_position = $PickUpItemPositionRotation/PickUpItemPosition.global_position

func place_explosive():
	if explosive_countdown.is_stopped():
		explosive_countdown.start()
		sabotage_button.modulate.a = 0.5
		place_c4.rpc()
	else:
		return

@rpc("any_peer", "call_local")
func place_c4():
	var explosive_device = explosive.instantiate()
	get_parent().add_child(explosive_device)
	explosive_device.global_position = $PickUpItemPositionRotation/PickUpItemPosition.global_position

func handle_invisible():
	if invisible_countdown.is_stopped() == false:
		return
	invisible_countdown.start()
	invisible_button.modulate.a = 0.5
	animated_sprite.modulate.a = 0.5
	self.turn_invisible.rpc()

	invisible_duration.start()
	await invisible_duration.timeout
	
	self.turn_visible.rpc()
	animated_sprite.modulate.a = 1

@rpc("any_peer", "call_remote")
func turn_invisible():
	invisible.emit(true)
	self.hide()

@rpc("any_peer", "call_remote")
func turn_visible():
	invisible.emit(false)
	self.show()

func _on_invisible_countdown_timeout():
	invisible_button.modulate.a = 1


func _on_explosive_cooldown_timeout():
	sabotage_button.modulate.a = 1


func _on_alien_release_cooldown_timeout():
	alien_release_button.modulate.a = 1
