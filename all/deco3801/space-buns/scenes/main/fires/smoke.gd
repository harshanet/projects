extends CharacterBody2D

const FLY_VELOCITY = -50

func _ready():
	$Animations.play("idle")

func _on_existence_timeout():
	self.queue_free()

func _physics_process(delta):
	velocity.y = FLY_VELOCITY
	move_and_slide()

