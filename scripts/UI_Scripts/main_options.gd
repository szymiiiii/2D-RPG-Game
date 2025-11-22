extends VBoxContainer


func _on_continue_pressed() -> void:
	GlobalVariables.is_continue_enabled = true
	SceneManager.swap_scenes("res://scenes/Gameplay.tscn" ,get_tree().root , self.get_parent().get_parent() ,"no_to_transition")
	


func _on_start_pressed() -> void:
	GlobalVariables.is_continue_enabled = false
	SceneManager.swap_scenes("res://scenes/Gameplay.tscn" ,get_tree().root , self.get_parent().get_parent() ,"no_to_transition")


func _on_options_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/UI/game_options.tscn",self.get_parent(),self,"no_to_transition")


func _on_przegladanie_map_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/UI/map_menu.tscn",self.get_parent(),self,"no_to_transition")
	##get_tree().change_scene_to_file("res://scenes/UI/UI_Mapy.tscn")
	print("mapy")


func _on_quit_pressed() -> void:
	print("quit")
	get_tree().quit()
	pass # Replace with function body.
