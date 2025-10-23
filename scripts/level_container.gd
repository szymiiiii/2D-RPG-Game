extends Node2D

func _ready() -> void:
	DoorManager.level_Container = self
	DoorManager.player_ready.connect(_on_player_ready)
	
	
func _on_player_ready():
	print("level_container_reset")
	reset_physics_interpolation()
