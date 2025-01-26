extends AnimatedSprite2D

func _ready():
	play("normal")

func destroy():
	play("destroyed")
