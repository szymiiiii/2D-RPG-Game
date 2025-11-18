extends VBoxContainer

func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_action("Exit"):
		if event.is_pressed() and not event.is_echo():
			self.visible = !self.visible

func _on_resume_pressed() -> void:
	print("resume")
	self.visible = !self.visible
	pass # Replace with function body.



func _on_return_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/UI/Main_Menu.tscn" ,get_tree().root , self.get_parent().get_parent().get_parent().get_parent() ,"no_to_transition")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_save_pressed() -> void:
	SaveGameManager.save()
	print("zapisano mapę")
	pass # Replace with function body.
