extends Node
signal signal1()
signal hiding

func _ready() -> void:	
	signal1.connect(_funkcja)
	
func _funkcja():
	GlobalVariables.curr_health == GlobalVariables.health
