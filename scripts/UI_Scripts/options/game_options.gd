extends VBoxContainer

var menu_interaction: FmodEvent = null

func _ready() -> void:
	menu_interaction = FmodServer.create_event_instance("event:/menu event")
	menu_interaction.volume = 0.5

func _on_main_options_pressed() -> void:
	menu_interaction.start()
	SceneManager.swap_scenes("res://scenes/UI/option_categories/general.tscn",self.get_parent(),self,"no_to_transition")


func _on_controls_pressed() -> void:
	menu_interaction.start()
	SceneManager.swap_scenes("res://scenes/UI/option_categories/controls.tscn",self.get_parent(),self,"no_to_transition")


func _on_return_pressed() -> void:
	menu_interaction.start()
	SceneManager.swap_scenes("res://scenes/UI/main_options.tscn",self.get_parent(),self,"no_to_transition")
