extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")	


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_body_entered(_body):
	$AnimatedSprite2D.play("open")

			


func _on_body_exited(_body):
	$AnimatedSprite2D.play("idle")	

func _on_area_2d_body_entered(body):
	if $AnimatedSprite2D.animation == "idle":
		body.queue_free()

func get_type():
	return "door"
