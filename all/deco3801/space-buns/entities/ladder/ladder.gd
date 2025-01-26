extends Node2D
class_name Ladder

@export var floor_collider: CollisionShape2D
@export var interaction_zone: CollisionShape2D

@onready var top_floor = $TopFloor
@onready var climbable_area = $ClimbableArea

func _ready():
	floor_collider.reparent(top_floor, true)
	interaction_zone.reparent(climbable_area, true)
