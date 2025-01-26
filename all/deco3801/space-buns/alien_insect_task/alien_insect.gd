extends CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED = 200.0
var hit_times = 0 # tracks how many times the bug has been shot
@onready var animator = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.

signal killed

func _ready():
	velocity = Vector2.RIGHT * SPEED # start it running right 
	$Area2D.body_entered.connect(_on_area_2d_body_entered)


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	apply_gravity(delta)
	var collision = move_and_collide(velocity * delta)
	# when the bug runs into a wall, it runs the other direction
	if collision:
		var bounce_velocity = velocity.bounce(collision.get_normal())
		velocity = bounce_velocity
	if (velocity.x < 0):
		animator.flip_h = true
	else:
		animator.flip_h = false

var flag = false

#Function used to synchronize being killed
@rpc("any_peer", "call_local")
func sync_kill():
	if not flag:
		flag = true
		killed.emit()
		self.queue_free()
	
func take_damage():
	hit_times += 1
	if (hit_times >= 6):
		sync_kill.rpc()

#Function handling taking damages from bullets
func _on_area_2d_body_entered(body):
	body.queue_free()
	take_damage()

