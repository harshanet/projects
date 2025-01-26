extends Resource
class_name MovementData

# Encapsulates a variety of settings used to describe player kinematics

@export var DURATION: float = INF # The duration this movement data lasts before being swapped out for the default

@export var MIN_SPEED: float # The minimum movement speed
@export var MAX_SPEED: float # The maximum movement speed

@export var ACCELERATION: float # The acceleration

@export var GLYCEMIC_INDEX: Curve # A curve describing how speed is interpolated between min and max over time

func sample(t):
	return lerpf(MIN_SPEED, MAX_SPEED, GLYCEMIC_INDEX.sample(t/DURATION)) # Sample the curve based on the current time
