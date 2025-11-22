extends VBoxContainer




func _on_main_options_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/UI/option_categories/general.tscn",self.get_parent(),self,"no_to_transition")


func _on_controls_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/UI/option_categories/controls.tscn",self.get_parent(),self,"no_to_transition")


func _on_return_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/UI/main_options.tscn",self.get_parent(),self,"no_to_transition")
