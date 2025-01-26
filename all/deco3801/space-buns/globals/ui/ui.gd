extends CanvasLayer
class_name UI

enum Position {
	INHERIT,
	CENTER	
}

@onready var default = $Padded
@onready var center = $Center

func request_draw(scene: PackedScene, pos: Position):
	var instance = scene.instantiate()
	
	match pos:
		Position.INHERIT: default.add_child(instance)
		Position.CENTER: 
			center.add_child(instance)

		
	return instance
