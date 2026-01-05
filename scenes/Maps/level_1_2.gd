extends Node2D

@onready var item_drop_1: Area2D = $ItemDrop
@onready var item_drop_2: Area2D = $ItemDrop2
@onready var item_drop_3: Area2D = $ItemDrop3
@onready var item_drop_4: Area2D = $ItemDrop4


func _ready() -> void:
	if_is_completed_remove(item_drop_1)
	if_is_completed_remove(item_drop_2)
	if_is_completed_remove(item_drop_3)
	if_is_completed_remove(item_drop_4)

func if_is_completed_remove(item_drop: Area2D):
		if GameProgressSaver.is_completed(item_drop.name):
			item_drop.queue_free()
