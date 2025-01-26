extends Control


# Called when the node enters the scene tree for the first time.
signal completed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $TextureProgressBar.value == $TextureProgressBar.max_value:
		completed.emit()
	

func increment(num):
	$TextureProgressBar.value += num 
