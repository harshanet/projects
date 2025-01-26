extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func delete():
	self.queue_free()

func get_clothing_name():
	return "lab_coat"
#All Functions below are used for animations purposes
func face_right():
	animation = "idle"

func face_left():
	animation = "idle"

func face_neutral():
	animation = "idle"

func climb_animation():
	if animation != "climb":
		animation = "climb"
	else:
		pass
		
func get_type():
	return "LabCoat"
