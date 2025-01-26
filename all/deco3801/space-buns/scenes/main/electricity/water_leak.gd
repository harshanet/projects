extends Area2D
var electrocutifized = false


# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	if not electrocutifized:
		for area in get_overlapping_areas():
			if area.has_method("get_type") and area.get_type() == "Electricity" and area.exploded:
				electrocutifized = true
	else:
		for body in get_overlapping_bodies():
			if (body.has_method("get_type")) and body.get_type() == "Player":
				if body.injured == false and body.ppe_worn == false:
					body.injured = true
					await get_tree().create_timer(1.5).timeout
					body.inflict_injury("Electrocuted")
					print(body.ppe_worn)
					
func get_type():
	return "WaterLeak"

func set_electric_charge(value):
	electrocutifized = value
