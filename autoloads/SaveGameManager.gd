extends Node

const SAVE_PATH := "user://save.tres"

var currentLevel: CurrentLevel

func _ready() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		_load()
	else:
		currentLevel = CurrentLevel.new()

func save() -> void:
	ResourceSaver.save(currentLevel, SAVE_PATH)

func _load():
	currentLevel = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	return currentLevel

func checkIfSaveExists():
	return ResourceLoader.exists(SAVE_PATH) && currentLevel.level_scene_path != null
