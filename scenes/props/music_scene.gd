extends Node2D

enum Songs {
	empty,
	main_menu,
	battle,

	pathway,
	house,
	office,
	boss,
	supermarket,
	coffe
	
	##Add new enum positions from below, so it wont break existing doors 
}

const SONG_PATHS = {
	Songs.empty: "empty",
	Songs.main_menu: "event:/main menu",
	Songs.battle: "event:/ost dom",

	Songs.pathway: "event:/ost dom",
	Songs.house: "event:/ost dom",
	Songs.office: "event:/ost dom",
	Songs.boss: "event:/ost dom",
	
	Songs.supermarket: "event:/ost dom",
	Songs.coffe: "event:/ost dom",
}

enum Ambience {
	empty,
	city,
	office,
	supermarket,
	wind
	
	##Add new enum positions from below, so it wont break existing doors 
}
const AMBIENCE_PATHS = {
	Ambience.empty: "empty",
	Ambience.city: "event:/city abmience",
	Ambience.office: "event:/room abmience",
	Ambience.supermarket: "event:/room abmience",
	Ambience.wind: "event:/wind abmience"
}



@export var songs: Songs
@export_range(0, 2) var volume: float
@export_range(0, 10000) var fade_in_time_msec: int

@export var ambience: Ambience
@export_range(0, 2) var amb_volume: float
@export_range(0, 10000) var amb_fade_in_time_msec: int

func _ready() -> void:
	#print("music scene")
	var path_to_play = SONG_PATHS[songs] 
	var path_amb_to_play = AMBIENCE_PATHS[ambience] 
	
	SignalBus.music_device_registration_to_player.emit(path_to_play, volume, fade_in_time_msec)
	MusicPlayer._play_ambience(path_amb_to_play, amb_volume, amb_fade_in_time_msec)
