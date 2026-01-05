extends Node

const SAVE_PATH := "user://currentLevelResource.tres"

var currentLevel: CurrentLevel

func _ready() -> void:
	#print(ResourceLoader.exists(SAVE_PATH))
	if ResourceLoader.exists(SAVE_PATH):
		_load()
	else:
		currentLevel = CurrentLevel.new()
		currentLevel.level_scene_path = ""
		currentLevel.player_position = Vector2(0, 0)
		save()

func save() -> void:
	ResourceSaver.save(currentLevel, SAVE_PATH)

func _load():
	currentLevel = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	return currentLevel

func checkIfSaveExists():
	return ResourceLoader.exists(SAVE_PATH) && currentLevel.level_scene_path != ""
