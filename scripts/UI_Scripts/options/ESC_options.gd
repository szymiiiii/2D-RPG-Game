extends VBoxContainer

var menu_interaction: FmodEvent = null
@onready var panel: Panel = $"../Panel"

func _ready() -> void:
	menu_interaction = FmodServer.create_event_instance("event:/menu event")
	menu_interaction.volume = 0.5

func _input(event: InputEvent) -> void:

	if event is InputEventKey && event.is_action("Exit"):
		if event.is_pressed() and not event.is_echo():
			panel.visible = !panel.visible
			self.visible = !self.visible
			GlobalVariables.is_idle_forced = !GlobalVariables.is_idle_forced
			menu_interaction.start()

func _on_resume_pressed() -> void:
	menu_interaction.start()
	print("resume")
	panel.visible = !panel.visible
	self.visible = !self.visible
	if !GlobalVariables.has_dialog_started:
		GlobalVariables.is_idle_forced = false
	pass # Replace with function body.



func _on_return_pressed() -> void:
	menu_interaction.start()
	GlobalVariables.is_idle_forced = false
	SceneManager.swap_scenes("res://scenes/UI/Main_Menu.tscn" ,get_tree().root , self.get_parent().get_parent().get_parent().get_parent() ,"no_to_transition")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	menu_interaction.start()
	pass # Replace with function body.


func _on_save_pressed() -> void:
	menu_interaction.start()
	SaveGameManager.save()
	panel.visible = !panel.visible
	self.visible = !self.visible
	print("zapisano mapę")
	if !GlobalVariables.has_dialog_started:
		GlobalVariables.is_idle_forced = false
	pass # Replace with function body.
