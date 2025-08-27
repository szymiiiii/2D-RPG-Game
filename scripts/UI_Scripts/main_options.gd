extends VBoxContainer


func _on_continue_pressed() -> void:
	print("continue")


func _on_start_pressed() -> void:
	print("start")


func _on_options_pressed() -> void:
	print("options")


func _on_przegladanie_map_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/UI/map_menu.tscn",self.get_parent(),self,"wipe_to_right")
	##get_tree().change_scene_to_file("res://scenes/UI/UI_Mapy.tscn")
	print("mapy")


func _on_quit_pressed() -> void:
	print("quit")
	get_tree().quit()
	pass # Replace with function body.
