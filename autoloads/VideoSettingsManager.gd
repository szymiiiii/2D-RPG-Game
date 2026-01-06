extends Node

var video_settings: Dictionary

func _ready() -> void:
	video_settings = ConfigFileManager.load_video_settings()
	pass
