extends Control

var video_settings: Dictionary
@onready var fullscreen_toggle: CheckButton = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/Button/HBoxContainer/FullscreenToggle
var menu_interaction: FmodEvent = null

func _ready():
	menu_interaction = FmodServer.create_event_instance("event:/menu event")
	menu_interaction.volume = 0.5
	video_settings = ConfigFileManager.load_video_settings()
	fullscreen_toggle.button_pressed = video_settings["fullscreen"]
	
func _on_return_pressed() -> void:
	menu_interaction.start()
	SceneManager.swap_scenes("res://scenes/UI/game_options.tscn",self.get_parent(),self,"no_to_transition")

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	menu_interaction.start()
	ConfigFileManager.save_video_setting("fullscreen", toggled_on)
	ConfigFileManager.set_fullscreen_mode()
	pass
