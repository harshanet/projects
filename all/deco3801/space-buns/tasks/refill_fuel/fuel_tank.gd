extends Area2D

var how_full = 0
@export var empty: Texture2D
@export var half: Texture2D
@export var full: Texture2D

func delete():
	self.queue_free()

var is_being_filled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):

	for thing in get_overlapping_areas():
		if (thing.get_type() == "Jerrycan") and (thing.is_pouring()):
			fill_more()
			thing.remove()


func fill_more():
	if how_full < 3:
		how_full += 1
		get_parent().progress_task()
		update_animation()

func update_animation():
	match how_full:
		0: $Sprite2D.texture = empty
		1: $Sprite2D.texture = half
		2: $Sprite2D.texture = full

func get_fullness():
	return how_full
