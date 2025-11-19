extends Node2D

var item_name
var item_quantity

func _ready() -> void:
	var random = randi() % 2
	if random == 0:
		item_name = "Orange"
	elif random == 1:
		item_name = "RedDiamond"
	
	$TextureRect.texture = load("res://assets/Items/" + item_name +".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = str(item_quantity)

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://item_icons/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)

func add_item_quantity(toAdd):
	item_quantity += toAdd
	$Label.text = str(item_quantity)
	
func decrease_item_quantity(toDec):
	item_quantity += toDec
	$Label.text = str(item_quantity)
