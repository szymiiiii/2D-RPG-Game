extends Node2D

func _ready() -> void:
	if randi() % 2 == 0:
		$TextureRect/TileMapLayer.set_cell(Vector2i(0,0), 1, Vector2i(0,3), 0)
	else:
		$TextureRect/TileMapLayer.set_cell(Vector2i(0,0), 1, Vector2i(1,0), 0)
