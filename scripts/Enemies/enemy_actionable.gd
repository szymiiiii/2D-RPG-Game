extends Area2D

const Balloon = preload("res://dialogue/balloon.tscn")
@onready var basic_enemy: Node2D = $".."

func action() -> void:
	#print("ballon started", !GlobalVariables.has_dialog_started)
	if !GlobalVariables.has_dialog_started:
		DialogueManager.show_example_dialogue_balloon(basic_enemy.dialogue_resource, basic_enemy.dialogue_start)


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if !basic_enemy.is_in_battle:
		GlobalVariables.cur_enemy = basic_enemy.get("boss_type")
		basic_enemy.is_in_battle = true
		action()
