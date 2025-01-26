class_name Bullet
extends CharacterBody2D


const SPEED = 200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2

func _ready():
	direction = Vector2(1,0).rotated(rotation)
	$AnimatedSprite2D.play("fire")

#Make the bullet fly until colliding
func _physics_process(delta):
	# Add the gravity.
	velocity = SPEED * direction
	var collision = move_and_collide(velocity * delta)
	if collision:
		self.queue_free()


func get_type():
	return "Bullet"


