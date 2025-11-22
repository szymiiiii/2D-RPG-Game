extends VBoxContainer

func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_action("Exit"):
		if event.is_pressed() and not event.is_echo():
			self.visible = !self.visible
			GlobalVariables.is_idle_forced = true

func _on_resume_pressed() -> void:
	print("resume")
	self.visible = !self.visible
	if !GlobalVariables.has_dialog_started:
		GlobalVariables.is_idle_forced = false
	pass # Replace with function body.



func _on_return_pressed() -> void:
	GlobalVariables.is_idle_forced = false
	SceneManager.swap_scenes("res://scenes/UI/Main_Menu.tscn" ,get_tree().root , self.get_parent().get_parent().get_parent().get_parent() ,"no_to_transition")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_save_pressed() -> void:
	SaveGameManager.save()
	self.visible = !self.visible
	print("zapisano mapę")
	if !GlobalVariables.has_dialog_started:
		GlobalVariables.is_idle_forced = false
	pass # Replace with function body.
