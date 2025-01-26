class_name CuredState
extends State

@export var actor : CharacterBody2D
@export var animator : AnimatedSprite2D
@onready var treatment_area = $"../../TreatmentArea"
@onready var injured_state = $"../NPCInjuredState" as InjuredState
const SPEED = 100.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
signal injured
var hit_times = 0

func _ready():
	set_physics_process(false)


@rpc("any_peer", "call_local")
func _enter_state() -> void:
	# NPC has been cured -> movement returns to normal and are not longer able 
	# to collide with medical equipment
	set_physics_process(true)
	actor.velocity = Vector2.RIGHT * SPEED
	treatment_area.set_collision_layer_value(7, false)
	treatment_area.set_collision_mask_value(8, false)

@rpc("any_peer", "call_local")
func _exit_state() -> void:
	# if NPC leaves the cured state, they have been injured and therefore
	# we need to disable their physics process so they are no longer walking
	set_physics_process(false)
	
func apply_gravity(delta):
	if not actor.is_on_floor():
		actor.velocity.y += gravity * delta
#Make NPCs move around
func _physics_process(delta):
	animator.play("walk")
	apply_gravity(delta)
	var collison = actor.move_and_collide(actor.velocity * delta)
	if collison:
		var bounce_velocity = actor.velocity.bounce(collison.get_normal())
		actor.velocity = bounce_velocity
		animator.flip_h = !animator.flip_h

func _on_hit_area_body_entered(body):
	body.queue_free()
	hit_times += 1
	if hit_times == 8:
		hit_times = 0
		injured.emit()
