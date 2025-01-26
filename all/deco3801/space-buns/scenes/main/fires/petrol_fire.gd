extends Area2D
var floating_text = preload("res://entities/floating_text/floating_text.tscn")
var message
var message_removed = false
var sprayedTime = 0
var died = false
# Called when the node enters the scene tree for the first time.
func _ready():
	TaskManager.register_hazard("Fire")
	message = floating_text.instantiate()
	message.message = "Petrol Fire"
	message.visible = false
	add_child(message)
	message.global_position = $MessagePosition.global_position
	$Smoke.play("idle")
	$Smoke2.play("idle")

func delete():
	TaskManager.remove_hazard("Fire")
	self.queue_free()

func die_animation():
	$AnimatedSprite2D.play("end")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (!died):
		$AnimatedSprite2D.play("burning")
	if (sprayedTime > 8):
		died = true
		die_animation()
		
func _on_area_entered(area):
	if area.has_method("get_type"):
		if (area.get_type() == "DryPowder") or (area.get_type() == "Foam"):
			sprayedTime += 1

func _on_animated_sprite_2d_animation_finished():
	if ($AnimatedSprite2D.animation == "end"):
		$AnimatedSprite2D.stop()
		delete()

				
func _on_body_entered(body):
	if (!message_removed):
		message.visible = true

func _on_body_exited(body):
	message.visible = false
	
func remove_message():
	message.visible = false
	message_removed = true
