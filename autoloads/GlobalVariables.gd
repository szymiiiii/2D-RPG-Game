extends Node

@export var health: int = 100
@export var curr_health: int = 0
@export var first: bool = false
@export var penguin: String = ""

func _set_health() -> void:
	#if first == false:
		pass
