class_name AlienAttackState
extends State
@export var actor : Alien
@export var animator : AnimatedSprite2D
@onready var detection_area = $"../../PlayerDetection"
@onready var wander_state = $"../WanderState"
@onready var attack_box = $"../../AttackBox"
@onready var firing_timer = $"../../Firing"
var bullet = preload("res://entities/effects/bullets/laser.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 110
const ACCELERATION = 120
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true)
	firing_timer.start()
	

func _exit_state() -> void:
	set_physics_process(false)
	firing_timer.stop()
	
func apply_gravity(delta):
	if not actor.is_on_floor():
		actor.velocity.y += gravity * delta
#Following players to attack
func _physics_process(delta):
	if detection_area.has_overlapping_bodies():
		animator.play("walk")
		var player_to_follow = detection_area.get_overlapping_bodies()[0]
		var direction = actor.global_position.direction_to(player_to_follow.global_position)
		if (actor.velocity.x > 0):
			animator.flip_h = true
			$"../../AttackRotation".rotation_degrees = -180
		else:
			animator.flip_h = false
			$"../../AttackRotation".rotation_degrees = 0
		apply_gravity(delta)
		actor.velocity = actor.velocity.move_toward(direction * SPEED, ACCELERATION * delta)
		actor.move_and_slide()
	else:
		get_parent().change_state_no_rpc(wander_state)

func fire():
	set_physics_process(false)
	animator.stop()
	var b = bullet.instantiate()
	b.global_position = $"../../AttackRotation/AttackPosition".global_position
	b.rotation_degrees = $"../../AttackRotation".rotation_degrees
	get_parent().get_parent().get_parent().add_child(b)
	await b.get_node("AnimatedSprite2D").animation_finished
	set_physics_process(true)
		

func _on_firing_timeout():
	fire()
	firing_timer.start()
