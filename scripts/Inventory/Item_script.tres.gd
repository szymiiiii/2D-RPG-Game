extends Node2D

@onready var item_name
@onready var item_descryption
@onready var item_quantity
@onready var item_category
@onready var item_variable

func _ready() -> void:
	var random = randi() % 2
	if random == 0:
		item_name = "Orange"
	elif random == 1:
		item_name = "RedDiamond"
	
	$TextureRect.texture = load("res://assets/Items/" + item_name +".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	item_descryption = str(JsonData.item_data[item_name]["Descryption"])
	item_category = str(JsonData.item_data[item_name]["ItemCategory"])
	item_variable = int(JsonData.item_data[item_name]["ItemVariable"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.text = str(item_quantity)

func set_item(nm, qt, dc, ct, iv):
	print("setting item: ", nm, ", quantity: ", qt, ", with a descryption: ", dc)
	item_name = nm
	item_quantity = qt
	item_descryption = dc
	item_category = ct
	item_variable = iv
	$TextureRect.texture = load("res://assets/Items/" + item_name + ".png")
	
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = str(item_quantity)

func add_item_quantity(toAdd):
	item_quantity += toAdd
	$Label.text = str(item_quantity)
	
func decrease_item_quantity(toDec):
	item_quantity -= toDec
	$Label.text = str(item_quantity)
