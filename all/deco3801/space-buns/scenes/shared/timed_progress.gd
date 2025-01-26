extends Node2D

signal timeout

@onready var bar = $ProgressBar
@onready var timer = $Timer
@onready var ship = $Ship

@onready var label = $Label

const REMAINING_TEXT = "TIME REMAINING: %s:%s"

var start = 0
var end

# Called when the node enters the scene tree for the first time.
func _ready():
	end = bar.get_rect().end.x
	timer.timeout.connect(func(): timeout.emit())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): # Every frame update the progress bar filled percentage and move the rocket along with it, also update the text
	var progress = 1 - (timer.time_left / timer.wait_time)
	bar.value = 100 * progress
	ship.position.x = lerpf(start, end, progress)
	label.text = REMAINING_TEXT % [str(int(timer.time_left / 60)).lpad(2, "0"), str(int(timer.time_left) % 60).lpad(2, "0")]
