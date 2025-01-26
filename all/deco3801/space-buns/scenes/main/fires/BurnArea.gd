extends Area2D


func _physics_process(delta):
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			if body.has_method("get_type") and body.get_type() == "Player":
				if body.injured == false:
					body.injured = true
					await get_tree().create_timer(0.5).timeout
					body.inflict_injury("Burn")
