extends Node2D
@onready var user_interface: CanvasLayer = $UserInterface
func _ready() -> void:
	SignalBus.is_in_battle.connect(_create_battle_instance)

func _create_battle_instance():
	user_interface.add_child(preload("res://scenes/Battle/Battle1.tscn").instantiate())
