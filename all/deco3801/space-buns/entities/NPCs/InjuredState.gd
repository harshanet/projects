class_name InjuredState
extends State
var text = null
var injury_message
var treatment_message
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var progress_bar_scene = preload("res://entities/progress_bar/progress_bar.tscn")
var progress_bar
var player_body
var player_text
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var actor : CharacterBody2D
@export var animator : AnimatedSprite2D
@onready var treatment_area = $"../../TreatmentArea"
@onready var progress_timer = $Timer
# contains all the treaments to the given possible injuries 
var injury_treatments = {
	"SprainedAnkles":  ["IcePack", "Bandage"],
	"AllergicReaction":  ["EpinephrineInjector"],
	"Burn":  ["ColdWater", "Bandage"],
	"COPoison": ["Inhaler"],
	"WoundRustyObject": ["Antiseptic", "TetanusInjection"],
	"Electrocuted": ["CurrentStop", "ColdWater", "Bandage"],
	"Eliminated": ["None"]
}

var treatment_steps = {}
var injury = "Burn"
signal cured

func check_treatment_completed():
	for step in treatment_steps.keys():
		if treatment_steps[step] != true:
			return false
	return true		


func _ready():
	set_process(false)	

func register_injury():
	treatment_steps.clear()
	for step in injury_treatments[injury]:
		treatment_steps[step] = false

@rpc("any_peer", "call_local")
func set_injury(value):
	injury = value
	

@rpc("any_peer", "call_local")
func _enter_state():
	set_process(true)
	treatment_area.set_collision_layer_value(7, true)
	treatment_area.set_collision_mask_value(8, true)
	text = floating_text.instantiate()
	injury_message = "Injury: " + injury + "\nPlease help me.."
	treatment_message = "Wrong treatment, I need "
	for item in injury_treatments[injury]:
		treatment_message += item + ", " 
	text.message = injury_message
	actor.add_child(text)
	text.global_position.y -= 15
	match injury:
		"Electrocuted":
			animator.play("electrocuted")
		_:
			animator.play("injured")
	actor.set_physics_process(false)
	register_injury()
	if (actor.get_type() == "Player"):
		$"../../CollisionShape2D".rotation_degrees = 90
		get_parent().get_parent().status_changed.emit('injured', true)
	actor.velocity.x = 0


@rpc("any_peer", "call_local")
func _exit_state():
	if text != null:
		text.queue_free()
	treatment_area.set_collision_layer_value(7, false)
	treatment_area.set_collision_mask_value(8, false)
	set_process(false)
	if (actor.get_type() == "Player"):
		$"../../CollisionShape2D".rotation_degrees = 0
		get_parent().get_parent().status_changed.emit('injured', false)
	actor.set_physics_process(true)

func complete_step(item_type):
	progress_timer.start()
	await progress_bar.completed
	treatment_steps[item_type] = true
	progress_bar.queue_free()
	progress_timer.stop()
	if check_treatment_completed():
		injury = "Burn"
		cured.emit()

func check_order(step):
	var right_step = true
	text.visible = false
	for i in treatment_steps.keys():
		if (i == step):
			break
		elif treatment_steps[i] == false:
			return false
	return true
#Handling first aid treatments
func _process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += gravity * delta
	actor.move_and_slide()
	if injury == "Electrocuted":
		var electrical_safe = true
		if treatment_area.has_overlapping_areas():
			for area in treatment_area.get_overlapping_areas():
				if (area.has_method("get_type")):
					if area.get_type() == "WaterLeak" and area.visible == true:
						electrical_safe = false
						break
					if area.get_type() == "Electricity":
						electrical_safe = false
						break
		if electrical_safe:
			treatment_steps["CurrentStop"] = true
			animator.play("injured")
	if treatment_area.has_overlapping_areas():
		var item = null
		for area in treatment_area.get_overlapping_areas():
			if area.get_collision_layer_value(8) == true:
				item = area
		if item != null and treatment_steps.has(item.get_type()) and check_order(item.get_type()) and (item.is_activated()):
			progress_bar = progress_bar_scene.instantiate()
			text.visible = false
			progress_bar.position.y -= 20
			actor.add_child(progress_bar)
			var item_type = item.get_type()
			player_body.throw_item.rpc()
			complete_step(item_type)

func _on_treatment_area_body_entered(body):
	player_body = body


func _on_timer_timeout():
	progress_bar.increment(10)
	progress_timer.start()
