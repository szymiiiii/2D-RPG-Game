extends VBoxContainer

func _on_mapa_nr_1_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/Gameplay.tscn" ,get_tree().root , self.get_parent().get_parent() ,"fade_to_black")


func _on_mapa_nr_2_pressed() -> void:
	pass # Replace with function body.


func _on_mapa_nr_3_pressed() -> void:
	pass # Replace with function body.


func _on_mapa_nr_4_pressed() -> void:
	pass # Replace with function body.


func _on_return_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/UI/main_options.tscn",self.get_parent(),self,"no_to_transition")
