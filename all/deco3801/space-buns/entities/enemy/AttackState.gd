class_name AttackState
extends State
@export var actor : RoboticEnemy
@export var animator : AnimatedSprite2D
@onready var detection_area = $"../../PlayerDetection"
@onready var firing_timer = $"../../Firing"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 150.0
const ACCELERATION = 160.0
var bullet
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)
#Handling entering the attacking state for enemies
@rpc("any_peer", "call_local")
func _enter_state() -> void:
	set_physics_process(true)
	animator.stop()
	animator.play("attack")
	firing_timer.start()
	firing_timer.timeout.connect(attack)
#Handling exiting the attacking state for enemies
@rpc("any_peer", "call_local")
func _exit_state() -> void:
	set_physics_process(false)
	animator.animation_finished.disconnect(attack)
	firing_timer.stop()
	
func apply_gravity(delta):
	if not actor.is_on_floor():
		actor.velocity.y += gravity * delta

func _physics_process(delta):
	if detection_area.has_overlapping_bodies():
		var player_to_follow = detection_area.get_overlapping_bodies()[0]
		var direction = actor.global_position.direction_to(player_to_follow.global_position)
		if (actor.velocity.x < 0):
			animator.flip_h = true
			$"../../GunRotation".rotation_degrees = -180
		else:
			animator.flip_h = false
			$"../../GunRotation".rotation_degrees = 0
		apply_gravity(delta)
		#Make the enemy follow the player
		actor.velocity = actor.velocity.move_toward(direction * SPEED, ACCELERATION * delta)
		actor.move_and_slide()


func attack():
	fire()
	firing_timer.start()
#Function used to fire bullets
@rpc("any_peer", "call_local")
func fire():
	var b = bullet.instantiate()
	b.global_position = $"../../GunRotation/BulletSpawn".global_position
	b.rotation_degrees = $"../../GunRotation".rotation_degrees
	get_tree().root.add_child(b)
	
