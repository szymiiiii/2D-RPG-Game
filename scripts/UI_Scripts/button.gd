extends Control

var ButtonClass = preload("res://scenes/Battle/Button1.tscn")
var BattleClass = load("res://scripts/UI_Scripts/battle.gd")
signal press
#var battle

func _ready() -> void:
#	battle = BattleClass.instantiate()
	press.connect(_on_magic_button_pressed)

func _on_magic_button_pressed() -> void:
	for i in PlayerInventory.inventory:
		if PlayerInventory.inventory[i][0] == $MagicButton.text and PlayerInventory.inventory[i][1] == int($MagicButton/Label.text):
			PlayerInventory.inventory[i][1] -= 1
			$MagicButton/Label.text = str(PlayerInventory.inventory[i][1])
			if PlayerInventory.inventory[i][3] == "Resource":
				print("Hi")
				GlobalVariables.curr_health = max(0, GlobalVariables.curr_health + PlayerInventory.inventory[i][4]) 
				SignalBus.health_up.emit()
			if PlayerInventory.inventory[i][1] == 0:
				print("Erase")
				PlayerInventory.inventory.erase(i)
			SignalBus.hiding.emit()

func button_check():
	pass
