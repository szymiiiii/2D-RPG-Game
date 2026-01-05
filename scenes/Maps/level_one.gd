extends Node2D

@onready var basic_enemy: Node2D = $BasicEnemy

func _ready() -> void:
	if_is_completed_remove(basic_enemy)

func if_is_completed_remove(item_drop: Node2D):
		if GameProgressSaver.is_completed(item_drop.name):
			item_drop.queue_free()
