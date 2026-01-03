extends Node

var ost_sound_event: FmodEvent = null
var current_ost_path: String = ""

var ambience_sound_event: FmodEvent = null
var current_ambience_path: String = ""

func _ready() -> void:	
	SignalBus.music_device_registration_to_player.connect(_play_audio_ost)

func _play_audio_ost(sound_path: String, volume: float, fade_in_time_msec: int):
	#print("play_audio_ost")
	if current_ost_path == sound_path:
		#print("nie ma dublowania")
		pass
	else:
		current_ost_path = sound_path
		if ost_sound_event != null:
			ost_sound_event.stop(FmodServer.FMOD_STUDIO_STOP_ALLOWFADEOUT)
			ost_sound_event.release()
		if sound_path != "empty":
			ost_sound_event = FmodServer.create_event_instance(sound_path)
			if !fade_in_time_msec > 0:
				ost_sound_event.volume = volume
				ost_sound_event.start()
			else:
				ost_sound_event.volume = 0
				ost_sound_event.start()
				var fade_time_temp = fade_in_time_msec
				while(fade_time_temp > 0):
					ost_sound_event.volume += volume/(fade_in_time_msec/5)
					await get_tree().create_timer(0.005).timeout
					fade_time_temp -= 5
			
func _play_ambience(sound_path: String, volume: float, fade_in_time_msec: int):
	if current_ambience_path == sound_path:
		#print("nie ma dublowania")
		pass
	else:
		current_ambience_path = sound_path
		if ambience_sound_event != null:
			ambience_sound_event.stop(FmodServer.FMOD_STUDIO_STOP_ALLOWFADEOUT)
			ambience_sound_event.release()
		if sound_path != "empty":
			ambience_sound_event = FmodServer.create_event_instance(sound_path)
			if !fade_in_time_msec > 0:
				ambience_sound_event.volume = volume
				ambience_sound_event.start()
			else:
				ambience_sound_event.volume = 0
				ambience_sound_event.start()
				var fade_time_temp = fade_in_time_msec
				while(fade_time_temp > 0):
					ambience_sound_event.volume += volume/(fade_in_time_msec/5)
					await get_tree().create_timer(0.005).timeout
					fade_time_temp -= 5
			
func _process(delta: float) -> void:
	pass
	#if !current_ost_path == "" :
		#if ost_sound_event.FMOD_STUDIO_PLAYBACK_STOPPED:
			#ost_sound_event.start()
			#
	#if !current_ambience_path == "" :
		#if ambience_sound_event.FMOD_STUDIO_PLAYBACK_STOPPED:
			#ambience_sound_event.start()
			
	
