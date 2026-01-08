extends Resource
class_name DialogueProgress

@export var history: Dictionary = {}

func is_completed(id: String) -> bool:
	return history.get(id, false)

func mark_as_done(id: String):
	history[id] = true
	emit_changed()
