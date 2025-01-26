class_name UnactivatedState
extends State
@export var actor : RoboticEnemy
@export var animator : AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)

@rpc("any_peer", "call_local")
func _enter_state() -> void:
	set_physics_process(true)
	animator.play("unactivated")
	$"../../PlayerDetection".set_collision_mask_value(13, false)


@rpc("any_peer", "call_local")
func _exit_state() -> void:
	$"../../PlayerDetection".set_collision_mask_value(13, true)
	set_physics_process(false)


func apply_gravity(delta):
	if not actor.is_on_floor():
		actor.velocity.y += gravity * delta
		
func _physics_process(delta):
	apply_gravity(delta)
	actor.move_and_slide()
