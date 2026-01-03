extends VBoxContainer

@onready var continueButton: Button = $Continue
var menu_interaction: FmodEvent = null

func _ready() -> void:
	print(SaveGameManager.checkIfSaveExists())
	continueButton.visible = SaveGameManager.checkIfSaveExists()
	menu_interaction = FmodServer.create_event_instance("event:/menu event")
	menu_interaction.set_parameter_by_name("Reverb Mix", 0.5)
	menu_interaction.volume = 0.5

func _on_continue_pressed() -> void:
	menu_interaction.set_parameter_by_name("Reverb Mix", 1.0)
	menu_interaction.start()
	if SaveGameManager.checkIfSaveExists():
		GlobalVariables.is_continue_enabled = true
		
		##Only use this signal in this script
		SceneManager.start_swapping.emit()
		
		SceneManager.swap_scenes("res://scenes/Gameplay.tscn" ,get_tree().root , self.get_parent().get_parent() ,"no_to_transition")
	else:
		print("nie ma pliku zapisu gry")


func _on_start_pressed() -> void:
	menu_interaction.set_parameter_by_name("Reverb Mix", 1.0)
	menu_interaction.start()
	GlobalVariables.is_continue_enabled = false
	
	##Only use this signal in this script
	SceneManager.start_swapping.emit()
		
	SceneManager.swap_scenes("res://scenes/Gameplay.tscn" ,get_tree().root , self.get_parent().get_parent() ,"no_to_transition")
	

func _on_options_pressed() -> void:
	menu_interaction.start()
	SceneManager.swap_scenes("res://scenes/UI/game_options.tscn",self.get_parent(),self,"no_to_transition")


func _on_przegladanie_map_pressed() -> void:
	#if(!menu_interaction.get_playback_state() == menu_interaction.FMOD_STUDIO_PLAYBACK_PLAYING):
	menu_interaction.start()
	SceneManager.swap_scenes("res://scenes/UI/map_menu.tscn",self.get_parent(),self,"no_to_transition")
	##get_tree().change_scene_to_file("res://scenes/UI/UI_Mapy.tscn")
	print("mapy")


func _on_quit_pressed() -> void:
	print("quit")
	get_tree().quit()
	pass # Replace with function body.
