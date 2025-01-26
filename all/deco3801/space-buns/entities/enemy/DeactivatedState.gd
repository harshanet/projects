class_name DeactivatedState
extends State

@export var actor : RoboticEnemy
@export var animator : AnimatedSprite2D
@onready var waiting_state = $"../WaitingState" as WaitingState
# Called when the node enters the scene tree for the first time.


@rpc("any_peer", "call_local")
func _enter_state() -> void:
	set_physics_process(true)
	animator.play("hurt")
	await get_tree().create_timer(10.0).timeout
	get_parent().change_state_no_rpc(waiting_state)

@rpc("any_peer", "call_local")
func _exit_state() -> void:
	pass
