extends Node
signal signal1()
signal is_in_battle()
signal battle_ended(enemy_died: bool)
signal music_device_registration_to_player(sound_path: String, volume: float, fade_in_time_msec: int)
signal hiding
signal health_up

func _ready() -> void:	
	signal1.connect(_funkcja)
	
func _funkcja():
	GlobalVariables.curr_health == GlobalVariables.health
