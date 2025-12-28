extends Control

var ButtonClass = preload("res://scenes/Battle/Button1.tscn")

signal press

func _ready() -> void:
	press.connect(_on_magic_button_pressed)

func _on_magic_button_pressed() -> void:
	for i in PlayerInventory.inventory:
		if PlayerInventory.inventory[i][0] == $MagicButton.text and PlayerInventory.inventory[i][1] == int($MagicButton/Label.text):
			PlayerInventory.inventory[i][1] -= 1
			$MagicButton/Label.text = str(PlayerInventory.inventory[i][1])
			if PlayerInventory.inventory[i][1] == 0:
				PlayerInventory.inventory.erase(i)
			SignalBus.hiding.emit()

func button_check():
	pass
