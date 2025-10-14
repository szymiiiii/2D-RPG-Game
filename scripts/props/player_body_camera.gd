extends Camera2D

func _ready() -> void:
	DoorManager.player_ready_to_teleport_to_door.connect(self._on_ready_to_teleport_to_door)

func _on_ready_to_teleport_to_door():
	var teleport_position = DoorManager.door_dictionary["door_position"]
	print("camera physics reset")
	reset_physics_interpolation()
	make_current()
