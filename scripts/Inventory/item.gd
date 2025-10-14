extends Node
class_name Item

@export var item_name: String = ""
@export var texture: Texture2D
@export var stackable: bool = false

func _ready() -> void:
	add_to_group("items")
