extends Area2D
var exploded = false
var hit_times = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$WaterLeak.hide()


func blow_up():
	if (not exploded):
		$WaterLeak.show()
		$WaterLeak.set_physics_process(true)
		exploded = true


func _on_body_entered(body):
	if (hit_times <= 30):
		hit_times += 1
	elif not exploded:
		$WaterLeak.show()
		$WaterLeak.set_physics_process(true)
		exploded = true
	if not exploded:
		body.queue_free()

