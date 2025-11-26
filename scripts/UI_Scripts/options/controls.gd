extends Control

@onready var input_button_scene = preload("res://scenes/UI/option_categories/control_button.tscn")
@onready var action_list: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"Running": "Run",
	"Move_Left": "Move Left",
	"Move_Right": "Move Right",
	"Jumping": "Jump",
	"Move_Down": "Move Down",
	"Interact": "Interact",
	"Exit": "Exit",
	"Inventory": "Inventory",
	"pickup": "Pickup"
}

func _ready():
	_create_action_list()


func _create_action_list():
	for item in action_list.get_children():
		item.queue_free()
		
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("Action Name")
		var input_label = button.find_child("Action Key")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_button_pressed.bind(button, action))
	
func _on_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("Action Key").text = "Press key to bind..."
	pass

func _input(event):
	if is_remapping:
		if (
			event is InputEventKey || 
			(event is InputEventMouseButton && event.pressed)
			):
				InputMap.action_erase_events(action_to_remap)
				
				InputMap.action_add_event(action_to_remap, event)
				ConfigFileManager.save_keybindings(action_to_remap, event)
				
				_update_action_list(remapping_button, event)
				
				is_remapping = false
				action_to_remap = null
				remapping_button = null
				
				accept_event()
				
				
func _update_action_list(button, event):
	button.find_child("Action Key").text = event.as_text().trim_suffix(" (Physical)")
				
		


func _on_default_pressed() -> void:
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			ConfigFileManager.save_keybindings(action, events[0])
	_create_action_list()


func _on_return_pressed() -> void:
	SceneManager.swap_scenes("res://scenes/UI/game_options.tscn",self.get_parent(),self,"no_to_transition")
