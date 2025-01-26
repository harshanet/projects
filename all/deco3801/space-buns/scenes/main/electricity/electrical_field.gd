extends Area2D

var hit_times = 0
var exploded = false

func _ready():

	$Explosion.hide()
	$Electricity.hide()

func _on_body_entered(body):
	if (body.has_method("get_type")) and (body.get_type() == "Bullet"):
		if hit_times <= 30:
			hit_times += 1
		elif not exploded:
			$Explosion.visible = true
			$Explosion.play("explode")
			exploded = true
		if not exploded:
			body.queue_free()

func blow_up():
	if (not exploded):
		TaskManager.register_hazard("Electrocution Hazard")
		$Explosion.visible = true
		$Explosion.play("explode")
		exploded = true
func _physics_process(delta):
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			if (body.has_method("get_type")) and (body.get_type() == "Player") and (exploded == true):
				if body.injured == false and body.ppe_worn == false:
					body.injured = true
					body.inflict_injury("Electrocuted")
					print(body.ppe_worn)

func _on_explosion_animation_finished():
	$Explosion.hide()
	$Electricity.show()
	
func get_type():
	if exploded:
		return "Electricity"
	else: 
		return null


func _on_area_entered(area):
	if (area.has_method("get_type")) and (area.get_type() == "Electromagnetic Pulse") and exploded == true:
		exploded = false
		for a in get_overlapping_areas():
			if a.has_method("get_type") and a.get_type() == "WaterLeak":
				a.set_electric_charge(false)
		TaskManager.remove_hazard("Electrocution Hazard")
		self.queue_free()
