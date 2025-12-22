extends Panel

signal hovering_started
signal hovering_ended

var taken = preload("res://assets/Items/Item_slot_taken.png")
var empty = preload("res://assets/Items/Item_slot.png")

var taken_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var ItemClass = preload("res://scenes/Inventory/Item.tscn")
var item = null

var descryption = load("res://scenes/Inventory/Descryption.tscn")
var descryption_instance = descryption.instantiate()

var slot_index

@export var slotType: SlotType

enum SlotType{
	ITEMS,
	SHIRT,
	PANTS,
	SHOES
}

func _ready() -> void:
	taken_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	taken_style.texture = taken
	empty_style.texture = empty
	hovering_started.connect(hovering_start)
	hovering_ended.connect(hovering_end)
	#if randi() % 2 ==0:
	#	item = ItemClass.instantiate()
	#	add_child(item)
	refresh_style()


func refresh_style():
	if item==null:
		set('theme_override_styles/panel', empty_style)
	else:
		set('theme_override_styles/panel', taken_style)

func pickFromSlot():
	remove_child(item)
	var inv = find_parent("Inventory")
	inv.add_child(item)
	item = null
	refresh_style()
	
func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inv = find_parent("Inventory")
	inv.remove_child(item)
	add_child(item)
	refresh_style()

func initialize_item(item_name, item_quantity, item_descryption):
	if item == null:
		item = ItemClass.instantiate()
		add_child(item)
		item.set_item(item_name, item_quantity, item_descryption)
	else:
		item.set_item(item_name, item_quantity, item_descryption)
	refresh_style()
	
func hovering_start():
	if slotType == SlotType.ITEMS:
		descryption_instance.position = Vector2(50,50)
		var descryption_name = descryption_instance.get_node("TextureRect/VBoxContainer/Name")
		var descryption_desc = descryption_instance.get_node("TextureRect/VBoxContainer/Descryption")
		descryption_name.text = PlayerInventory.inventory[slot_index][0]
		descryption_desc.text = PlayerInventory.inventory[slot_index][2]
		var descrypton_location = get_node(".")
		descrypton_location.add_child(descryption_instance)
	else:
		descryption_instance.position = Vector2(50,50)
		var descryption_name = descryption_instance.get_node("TextureRect/VBoxContainer/Name")
		var descryption_desc = descryption_instance.get_node("TextureRect/VBoxContainer/Descryption")
		descryption_name.text = PlayerInventory.equips[slot_index][0]
		descryption_desc.text = PlayerInventory.equips[slot_index][2]
		var descrypton_location = get_node(".")
		descrypton_location.add_child(descryption_instance)
	
	
func hovering_end():
	await get_tree().create_timer(2.0).timeout
	remove_child(descryption_instance)
