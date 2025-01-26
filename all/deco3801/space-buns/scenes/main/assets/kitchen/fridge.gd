extends Area2D
class_name Fridge

@onready var animation = $AnimatedSprite2D

func _physics_process(delta):
	if has_overlapping_bodies():
		animation.animation = 'open'
	else:
		animation.animation = 'closed'

func get_type():
	return "Fridge"
