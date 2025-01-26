extends Area2D

@onready var explosion = $Explosion
@onready var fire = $Fire
@onready var electric = $Electric
@onready var bigger_fire = $BiggerFire
var spray_times = 0
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false
const NORMAL_FIRE_EXTINGUISH = 10
const BIGGER_FIRE_EXTINGUISH = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	TaskManager.register_hazard("Fire")
	explosion.visible = false
	bigger_fire.visible = false
	fire.play("idle")
	electric.play("idle")
	message = floating_text.instantiate()
	message.message = "Electric Fire"
	message.visible = false
	add_child(message)
	message.global_position = $MessagePosition.global_position
	$Smoke.play("idle")
	$Smoke2.play("idle")

func _on_area_entered(area):
	if area.has_method("get_type"):
		if area.get_type() == "CO2" or area.get_type() == "DryPowder":
			spray_times += 1
		elif area.get_type() == "WaterSpray" or area.get_type() == "Foam":
			explosion.visible = true
			fire.visible = false
			explosion.play("explode")

func _on_explosion_animation_finished():
	if explosion.visible:
		explosion.visible = false
		bigger_fire.visible = true
		bigger_fire.play("idle")

func _process(delta):
	if (spray_times >= NORMAL_FIRE_EXTINGUISH) and (!bigger_fire.visible):
		TaskManager.remove_hazard("Fire")
		self.queue_free()
	elif (spray_times >= BIGGER_FIRE_EXTINGUISH) and (bigger_fire.visible):
		TaskManager.remove_hazard("Fire")
		self.queue_free()



func _on_body_entered(body):
	if (!message_removed):
		message.visible = true

func _on_body_exited(body):
	message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
