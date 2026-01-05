extends Node2D

@onready var day_one: Node2D = $DayOne
@onready var day_two: Node2D = $DayTwo
@onready var day_three: Node2D = $DayThree

@onready var house_closed_door: Node2D = $Doors/HouseClosedDoor
@onready var house_toilet_door: Node2D = $Doors/HouseToiletDoor
@onready var house_entry_door: Node2D = $Doors/HouseEntryDoor

var are_doors_closed: bool
var ending_reached: bool = false

@onready var player: Player = $Player
@onready var player_body_camera: Camera2D = $Player/PlayerBodyCamera
@onready var ending: Node2D = $DayThree/Ending

func _ready() -> void:
	if GlobalVariables.special_transition == true && SceneManager._loading_screen != null:
		GlobalVariables.special_transition = false
		GlobalVariables.is_idle_forced = false
		player.reset_physics_interpolation()
		player_body_camera.reset_physics_interpolation()
		player_body_camera.make_current()
		SceneManager._loading_screen.finish_transition()
		
		# Wait or loading animation to finish
		await SceneManager._loading_screen.anim_player.animation_finished
	
		
	are_doors_closed = house_entry_door.get("are_doors_closed")
	if are_doors_closed && GameProgressSaver.is_completed("HouseToiletTutorial"):
		house_entry_door.set("are_doors_closed", false)
		are_doors_closed = false
	if !GameProgressSaver.is_completed("DayOne"):
		day_two.queue_free()
		day_three.queue_free()
	else:
		if !GameProgressSaver.is_completed("DayTwo"):
			day_one.queue_free()
			day_three.queue_free()
		else:
			day_one.queue_free()
			day_two.queue_free()
			if GameProgressSaver.is_completed("DayThreeQuest") && !GameProgressSaver.is_completed("LordOrigami"):
				house_closed_door.set("are_doors_closed", false)
			if GameProgressSaver.is_completed("LordOrigami"):
				house_entry_door.set("are_doors_closed", true)
				house_toilet_door.set("are_doors_closed", true)
				ending.visible = true
			else:
				ending.queue_free()
				
func _process(delta: float) -> void:
	if !ending_reached && GameProgressSaver.is_completed("EndingWithFriends"):
		ending_reached = true
		SceneManager._add_loading_screen("fade_to_black")
		GlobalVariables.is_idle_forced = true
		await get_tree().create_timer(1).timeout
		GlobalVariables.special_transition = true
		SceneManager.swap_scenes("res://scenes/Maps/ending_map.tscn", self.get_parent(), self, "no_transition")
