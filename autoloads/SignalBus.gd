extends Node
signal signal1()
signal textbox_closed
signal fireball()

func _ready() -> void:	
	signal1.connect(_funkcja)
	
func _funkcja():
	GlobalVariables.curr_health == GlobalVariables.health
