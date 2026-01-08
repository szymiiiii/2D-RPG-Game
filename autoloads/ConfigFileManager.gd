extends Node

var config_file = ConfigFile.new()

const SETTINGS_FILE_PATH = "user://settings.cfg"

func set_keybindings_to_default():
	config_file.set_value("keybinding", "Running", "Shift")
	config_file.set_value("keybinding", "Move_Left", "A")
	config_file.set_value("keybinding", "Move_Right", "D")
	config_file.set_value("keybinding", "Jumping", "W")
	config_file.set_value("keybinding", "Move_Down", "S")
	config_file.set_value("keybinding", "Interact", "Enter")
	config_file.set_value("keybinding", "Exit", "Escape")
	config_file.set_value("keybinding", "Inventory", "I")
	config_file.set_value("keybinding", "pickup", "F")

#AUDIO DODAM WRAZ Z FMOD
func set_audio_to_default():
	config_file.set_value("audio", "master", 100)
	config_file.set_value("audio", "environment", 100)
	config_file.set_value("audio", "enemies", 100)
	config_file.set_value("audio", "music", 100)

func set_video_to_default():
	config_file.set_value("video", "fullscreen", true)

func set_keybindings_InputMap():
	var keybindings = ConfigFileManager.load_keybindings()
	for action in keybindings.keys():
		#print(action, ", key: ", keybindings[action])
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybindings[action])
		
func set_fullscreen_mode():
	var video_settings = load_video_settings()
	var is_toggled = video_settings["fullscreen"]
	if is_toggled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		#print("zapis pliku cfg")
		set_keybindings_to_default()
		#set_audio_to_default()
		set_video_to_default()
		config_file.save(SETTINGS_FILE_PATH)
	else:
		#print("odczyt pliku cfg")
		config_file.load(SETTINGS_FILE_PATH)
	set_keybindings_InputMap()
	set_fullscreen_mode()

func save_video_setting(key: String, value):
	config_file.set_value("video", key, value)
	config_file.save(SETTINGS_FILE_PATH)
	
func load_video_settings():
	var video_settings = {}
	for key in config_file.get_section_keys("video"):
		video_settings[key] = config_file.get_value("video", key)
	return video_settings
	
func save_audio_setting(key: String, value):
	config_file.set_value("audio", key, value)
	config_file.save(SETTINGS_FILE_PATH)
	
func load_audio_settings():
	var audio_settings = {}
	for key in config_file.get_section_keys("audio"):
		audio_settings[key] = config_file.get_value("audio", key)
	return audio_settings

func save_keybindings(action: StringName, event: InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)
		
	config_file.set_value("keybinding", action, event_str)
	config_file.save(SETTINGS_FILE_PATH)
	
func load_keybindings():
	var keybindings = {} 
	var keys = config_file.get_section_keys("keybinding")
	for key in keys:
		var input_event
		var event_str = config_file.get_value("keybinding", key)
		#print(event_str)
		if event_str.contains("mouse_"):
			input_event = InputEventMouseButton.new()
			input_event.button_index = int(event_str.split("_")[1])
		else:
			input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
			
			keybindings[key] = input_event
	return keybindings
