extends Node

func _ready() -> void:
	if GlobalVariables.special_transition == true:
		DoorManager._clear_door_list()
