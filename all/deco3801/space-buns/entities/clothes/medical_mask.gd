extends Sprite2D

@export var mask_right: Texture2D
@export var mask_left: Texture2D
@export var mask_neutral: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func delete():
	self.queue_free()

func get_clothing_name():
	return "medical_mask"

func face_right():
	texture = mask_right

func face_left():
	texture = mask_left

func face_neutral():
	texture = mask_neutral

func get_type():
	return "MedicalMask"
