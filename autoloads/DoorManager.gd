extends Node

signal player_entered_doors(door_id: int, door_orientation: int, transition_name: String, next_map_name: String,  door_position: Vector2)
signal player_exited_doors()
signal player_ready_to_pass(timer_time: float)
signal all_door_registrate_in_scene_manager(door_node: Node2D, door_id: int)

var level_Container: Node2D = null

var is_player_inside_vertical_doors = false
var is_player_inside_horizontal_doors = false
var door_dictionary = {
	"door_id": 0,
	"door_orientation": 0,
	"transition_name": "",
	"next_map_name": "",
	"door_position": Vector2(0, 0)
}

func _ready() -> void:
	player_entered_doors.connect(self._on_player_in_doors)
	player_exited_doors.connect(self._on_player_exited_doors)
	player_ready_to_pass.connect(self._on_player_ready_to_pass)
	all_door_registrate_in_scene_manager.connect(self._on_all_door_registrate_in_scene_manager)
	_on_player_exited_doors()

func _on_player_in_doors(door_id: int, door_orientation: int, transition_name: String, next_map_name: String,  door_position: Vector2):
	if !(is_player_inside_vertical_doors || is_player_inside_horizontal_doors):
		if door_orientation == 2:
			is_player_inside_vertical_doors = true
		elif (door_orientation == 0 || door_orientation == 1):
			is_player_inside_horizontal_doors = true
		else:
			_on_player_exited_doors()
			printerr("door orientation drzwi nr " ,door_id,  " poza przedzialem 0, 1, 2 tylko: ", door_orientation)
			return
			
		door_dictionary = {
			"door_id": door_id,
			"door_orientation": door_orientation,
			"transition_name": transition_name,
			"next_map_name": next_map_name,
			"door_position": door_position
		}
		print("Door manager - door id: ", door_dictionary["door_id"], ", orient: ", door_dictionary["door_orientation"])
	else:
		printerr("Door manager - gracz juz jest w drzwiach a probuje dostac sie do kolejnych")

func _on_player_exited_doors():
	is_player_inside_vertical_doors = false
	is_player_inside_horizontal_doors = false
	
	door_dictionary = {
		"door_id": 0,
		"door_orientation": 0,
		"transition_name": "",
		"next_map_name": "",
		"door_position": Vector2(0, 0)
	}
	print("Door manager - gracz opuscil drzwi")

func _on_all_door_registrate_in_scene_manager(door_node: Node2D):
	pass
	
func _clear_door_list():
	pass

func _on_player_ready_to_pass(timer_time: float):
	await get_tree().create_timer(timer_time).timeout
	SceneManager.swap_scenes(door_dictionary["next_map_name"],level_Container,level_Container.get_child(0),door_dictionary["transition_name"])

	
