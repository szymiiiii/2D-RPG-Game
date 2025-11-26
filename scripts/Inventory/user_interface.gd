extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
		
func _ready() -> void:
	$Inventory.visible = false
