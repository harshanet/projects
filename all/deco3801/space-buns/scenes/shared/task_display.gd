extends VBoxContainer

const DESCRIPTION_FORMAT = "%s (%d/%d) [%s]"
var COMPLETE_COLOR = Color.from_string("#8ffe7e", Color.WHITE)

var task
var description

func initialise(name: String): # Draw a task to the screen
	task = name
	
	description = Label.new()
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	description.add_theme_font_size_override("font_size", 12)

	add_child(description)
	redraw()

func redraw(): # Redraw the task with the most up to date information
	var info = TaskManager.get_info(task)
	var status = TaskManager.get_checkpoint(task)
	
	description.text = DESCRIPTION_FORMAT % [info.name, status, info.checkpoints, info.location]

	
	if TaskManager.is_complete(task): # If the task is complete make it green in colour
		description.add_theme_color_override("font_color", COMPLETE_COLOR)
