extends Area2D

const Balloon = preload("res://dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	#print("ballon started", !GlobalVariables.has_dialog_started)
	if !GlobalVariables.has_dialog_started:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
	#var bal: Node = Balloon.instantiate()
	#bal.start(dialogue_resource, dialogue_start)
