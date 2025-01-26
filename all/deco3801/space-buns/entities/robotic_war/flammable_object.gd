extends Area2D
@export var flame : PackedScene
@export var object : AnimatedSprite2D
var hit_times = 0
var exploded = false

#Handling blowing up
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hit_times >= 20 and exploded == false:
		add_child(flame.instantiate())
		if object != null and object.has_method("destroy"):
			object.destroy()
		exploded = true

func blow_up():
	if (not exploded):
		add_child(flame.instantiate())
		if object != null and object.has_method("destroy"):
			object.destroy()
		exploded = true

func _on_body_entered(body):
	hit_times += 1
	if not exploded:
		body.queue_free()
