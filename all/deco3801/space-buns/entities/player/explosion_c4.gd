extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("explode")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.stop()
	if has_overlapping_areas():
		for area in get_overlapping_areas():
			if area.has_method("blow_up"):
				area.blow_up()
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			if body.has_method("get_type") and body.get_type() == "Player" and body.injured == false:
				body.injured = true
				print("hit player")
				body.inflict_injury("Burn")
	self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
