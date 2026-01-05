extends Node

const SAVE_PATH = "user://progressSaver.tres"
var progress: DialogueProgress 

func setup_new_game():
	progress = DialogueProgress.new()
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	print("Nowa gra rozpoczęta.")

func load_saved_game():
	if ResourceLoader.exists(SAVE_PATH):
		# Dodano .duplicate() dla bezpieczeństwa danych w RAM
		progress = ResourceLoader.load(SAVE_PATH).duplicate()
		print("Zapis załadowany.")
	else:
		setup_new_game()

func mark_dialogue_as_done(id: String):
	if progress:
		progress.history[id] = true

func save_game():
	if progress:
		var result = ResourceSaver.save(progress, SAVE_PATH)
		if result == OK:
			print("Gra zapisana przez gracza!")
		else:
			print("Błąd zapisu! Kod:", result)

func is_completed(id: String) -> bool:
	if progress:
		return progress.history.get(id, false)
	return false
