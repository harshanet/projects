extends VBoxContainer

const DESCRIPTION_FORMAT = "%s (%d)"
var DEFAULT_COLOR = Color.from_string("#fe8f8f", Color.WHITE)

var hazard
var description

func initialise(name: String): # Draw a hazard to the screen
	hazard = name
	
	description = Label.new()
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	description.add_theme_font_size_override("font_size", 12)
	description.add_theme_color_override("font_color", DEFAULT_COLOR)

	add_child(description)
	redraw()

func redraw(): # Redraw the hazard with the most up to date information
	if TaskManager.hazard_mitigated(hazard):
		self.queue_free()
	
	description.text = DESCRIPTION_FORMAT % [hazard, TaskManager.hazard_status(hazard)]
