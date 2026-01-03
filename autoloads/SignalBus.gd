extends Node
signal signal1()
signal textbox_closed
signal fireball()
signal is_in_battle()
signal battle_ended()
signal music_device_registration_to_player(sound_path: String, volume: float, fade_in_time_msec: int)

func _ready() -> void:	
	signal1.connect(_funkcja)
	
func _funkcja():
	GlobalVariables.curr_health == GlobalVariables.health
