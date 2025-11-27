extends Node2D


func _ready() -> void:
	DoorManager.level_Container = self
	DoorManager.player_ready.connect(_on_player_ready)
	SignalBus.battle_ended.connect(_battle_ended)
	SignalBus.is_in_battle.connect(_is_in_battle)
	load_level(SaveGameManager.currentLevel.level_scene_path)
	
func _is_in_battle():
	#print("is_in_battle levelcontainer setting process mode to false")
	get_child(0).process_mode = Node.PROCESS_MODE_DISABLED
	#get_child(0).set_process(false)
	#get_child(0).set_physics_process(false)
	#get_child(0).set_process_input(false)
		
func _battle_ended():
	get_child(0).process_mode = Node.PROCESS_MODE_ALWAYS

func load_level(path: String):
	SaveGameManager._load()
	var currentLevelPath = SaveGameManager.currentLevel.level_scene_path
	if(currentLevelPath == "" || !GlobalVariables.is_continue_enabled):
		add_child(load("res://scenes/Maps/house/house_bedroom.tscn").instantiate())
	else:
		
		add_child(load(currentLevelPath).instantiate())
		
func _on_player_ready():
	print("level_container_reset")
	reset_physics_interpolation()


func _on_child_entered_tree(node: Node) -> void:
	if node is Node2D:
		#print(node.scene_file_path)
		SaveGameManager.currentLevel.level_scene_path = node.scene_file_path
		#currentLevel = node
		
