extends Area2D


func get_type():
	return "Laser"
	

func _ready():
	$AnimatedSprite2D.play("fire")
	await $AnimatedSprite2D.animation_finished
	self.queue_free()

# Function used for inflicting injury on players -> collision layer masked
# to only see the player so any 'body' will be a player
func _on_body_entered(body):
	body.hit_times += 3
	if body.hit_times > 5:
		body.inflict_injury("Burn")
		body.hit_times = 0
