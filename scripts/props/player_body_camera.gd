extends Camera2D

#position coordinates to set when camera is not following player
@export var pos_x: int = 0
@export var pos_y: int = 0

func _ready() -> void:
	#print("cam pos - x: ", position.x, ", y: ", position.y)
	DoorManager.player_ready_to_teleport_to_door.connect(self._on_ready_to_teleport_to_door)

func _on_ready_to_teleport_to_door():
	#print("camera physics reset")
	make_current()
	reset_physics_interpolation()
	

	#if(get_parent().name != "Player"):
		#position.x = pos_x
		#position.y = pos_y
	
