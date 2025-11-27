extends Area2D

const Balloon = preload("res://dialogue/balloon.tscn")
@onready var basic_enemy: Node2D = $".."

func action() -> void:
	#print("ballon started", !GlobalVariables.has_dialog_started)
	if !GlobalVariables.has_dialog_started:
		DialogueManager.show_example_dialogue_balloon(basic_enemy.dialogue_resource, basic_enemy.dialogue_start)
		


func _on_body_entered(body: Node2D) -> void:
	if !basic_enemy.is_in_battle:
		basic_enemy.is_in_battle = true
		action()
