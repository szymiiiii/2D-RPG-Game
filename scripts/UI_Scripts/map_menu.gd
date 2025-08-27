extends VBoxContainer

func _on_mapa_nr_1_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/Gameplay.tscn" ,get_tree().root , get_tree().root.get_child(2),"no_to_transition")


func _on_mapa_nr_2_pressed() -> void:
	pass # Replace with function body.


func _on_mapa_nr_3_pressed() -> void:
	pass # Replace with function body.


func _on_mapa_nr_4_pressed() -> void:
	pass # Replace with function body.


func _on_return_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/UI/main_options.tscn",self.get_parent(),self,"no_to_transition")
