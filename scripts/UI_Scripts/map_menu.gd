extends VBoxContainer


func _on_mapa_nr_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Maps/scena_1.tscn")


func _on_mapa_nr_2_pressed() -> void:
	pass # Replace with function body.


func _on_mapa_nr_3_pressed() -> void:
	pass # Replace with function body.


func _on_mapa_nr_4_pressed() -> void:
	pass # Replace with function body.


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/Main_Menu.tscn")
