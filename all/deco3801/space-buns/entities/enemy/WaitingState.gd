class_name WaitingState
extends State
@export var actor : RoboticEnemy
@export var animator : AnimatedSprite2D
@onready var attack_state = $"../AttackState"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 100.0
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)

@rpc("any_peer", "call_local")
func _enter_state() -> void:
	set_physics_process(true)
	actor.velocity = Vector2.RIGHT * SPEED
	animator.play("walk")

@rpc("any_peer", "call_local")
func _exit_state() -> void:
	set_physics_process(false)
	animator.stop()

func apply_gravity(delta):
	if not actor.is_on_floor():
		actor.velocity.y += gravity * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Make enemy wander around until htting a wall
func _physics_process(delta):
	if $"../../PlayerDetection".has_overlapping_bodies():
		get_parent().change_state(attack_state)
	apply_gravity(delta)
	var collision = actor.move_and_collide(actor.velocity * delta)
	if collision:
		var bounce_velocity = actor.velocity.bounce(collision.get_normal())
		actor.velocity = bounce_velocity
	if (actor.velocity.x < 0):
		animator.flip_h = true
		$"../../GunRotation".rotation_degrees = -180
	else:
		animator.flip_h = false
		$"../../GunRotation".rotation_degrees = 0
