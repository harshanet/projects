class_name RoboticEnemy
extends CharacterBody2D

@onready var finite_state_machine = $FiniteStateMachine as FiniteStateMachine
@onready var waiting_state = $FiniteStateMachine/WaitingState as WaitingState
@onready var death_state = $FiniteStateMachine/DeathState as DeathState
@onready var attack_state = $FiniteStateMachine/AttackState as AttackState
@onready var unactivated_state = $FiniteStateMachine/UnactivatedState as UnactivatedState
@onready var deactivated_state = $FiniteStateMachine/DeactivatedState as DeactivatedState
@export var animations : SpriteFrames
@export var projectile : PackedScene

var hit_times = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.


func _ready():
	$AnimatedSprite2D.set_sprite_frames(animations)
	attack_state.bullet = projectile
	Signals.ActivateRobots.connect(handle_activation)
	Signals.connect("DeactivateRobots", finite_state_machine.change_state_no_rpc.bind(death_state))

func handle_activation(target_all: bool):
	if target_all == true:
		$PlayerDetection.set_collision_mask_value(2, true)
	finite_state_machine.change_state(waiting_state)

func get_type():
	return "RoboticEnemy"

func _process(delta):
	if hit_times >= 30:
		finite_state_machine.change_state_no_rpc(deactivated_state)
		hit_times = 0
#Functions detecting players 
func _on_player_detection_body_entered(body):
	if body.has_method("get_type"):
		if body.get_type() != "RoboticEnemy" and finite_state_machine.state != attack_state:
			finite_state_machine.change_state_no_rpc(attack_state)


func _on_player_detection_body_exited(body):
	if body.has_method("get_type"):
		if body.get_type() != "RoboticEnemy" and finite_state_machine.state == attack_state:
			finite_state_machine.change_state_no_rpc(waiting_state)
#Function handling being hit by bullets
func _on_hit_area_body_entered(body):
	if finite_state_machine.state != unactivated_state and finite_state_machine.state != deactivated_state:
		if (body.has_method("get_type")):
			if body.get_type() == "Bullet":
				hit_times += 1
				print(hit_times)
				body.queue_free()
