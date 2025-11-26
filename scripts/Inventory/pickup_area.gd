extends Area2D


var items_in_range = {}


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#print("body_entered")
	items_in_range[area] = area


func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#print("body_exited")
	if items_in_range.has(area):
		items_in_range.erase(area)
