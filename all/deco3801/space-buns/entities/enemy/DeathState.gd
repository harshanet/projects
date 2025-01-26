class_name DeathState
extends State


@export var actor : RoboticEnemy
@export var animator : AnimatedSprite2D
# Called when the node enters the scene tree for the first time.

@rpc("any_peer", "call_local")
func _enter_state() -> void:
	animator.play("death")
	$"../../PlayerDetection".set_collision_mask_value(13, false)
	actor.velocity.x = 0
	
@rpc("any_peer", "call_local")
func _exit_state() -> void:
	$"../../PlayerDetection".set_collision_mask_value(13, true)




func _on_animated_sprite_2d_animation_finished():
	if animator.animation == "death":
		animator.stop()
