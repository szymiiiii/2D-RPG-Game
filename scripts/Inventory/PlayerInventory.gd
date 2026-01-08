extends Node

const SlotClass = preload("res://scripts/Inventory/slot.gd")
const ItemClass = preload("res://scripts/Inventory/Item_script.tres.gd")
const NUM_INVENTORY_SLOTS = 24

var inventory = {
	0: ["Orange", 1, "Heals 20 HP", "Resource", 20],
	1: ["RedDiamond", 23, "Worthless", "Resource", 0],
	2: ["RedDiamond", 95, "Worthless", "Resource", 0]
}

var equips = {
	0: ["The Coat", 1, "Imagination tailored", "Shirt", 2],
	1: ["The Pants", 1, "Imagination tailored", "Pants", 2],
	2: ["The Boots", 1, "Imagination tailored", "Shoes", 2],
	3: ["The Sword", 1, "Imagination tailored", "Sword", 5]
}

var inventory_ui = null

const SAVE_PATH = "user://inventory_save.tres"

func load_starting_inventory():
	inventory = {
		0: ["Orange", 1, "Heals 20 HP", "Resource", 20],
		1: ["RedDiamond", 23, "Worthless", "Resource", 0],
		2: ["RedDiamond", 95, "Worthless", "Resource", 0]
	}

	equips = {
		0: ["The Coat", 1, "Imagination tailored", "Shirt", 2],
		1: ["The Pants", 1, "Imagination tailored", "Pants", 2],
		2: ["The Boots", 1, "Imagination tailored", "Shoes", 2],
		3: ["The Sword", 1, "Imagination tailored", "Sword", 5]
	}
func save_inventory():
	var save_data = Inventory_Resource.new()
	
	save_data.inventory = inventory.duplicate(true)
	save_data.equips = equips.duplicate(true)
	
	var result = ResourceSaver.save(save_data, SAVE_PATH)
	if result != OK:
		print("Błąd podczas zapisu ekwipunku: ", result)

func load_inventory():
	if not FileAccess.file_exists(SAVE_PATH):
		print("Nie znaleziono pliku zapisu ekwipunku.")
		return

	var loaded_data = ResourceLoader.load(SAVE_PATH) as Inventory_Resource
	
	if loaded_data:
		inventory = loaded_data.inventory.duplicate(true)
		equips = loaded_data.equips.duplicate(true)

func add_item(item_name, item_quanity, item_descryption, item_category, item_variable):
	#print("add_item: ", item_name, ", quantity: ", item_quanity)
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quanity:
				inventory[item][1] += item_quanity
				update_slot_visual(item, inventory[item][0], inventory[item][1], inventory[item][2], inventory[item][3], inventory[item][4])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1], inventory[item][2], inventory[item][3], inventory[item][4])
				item_quanity = item_quanity - able_to_add
			#TODO Check if slot is full
			#inventory[item][1] += item_quanity
			#return
			
	# PlayerInventory.gd

	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			# MUSISZ dodać wszystkie parametry, inaczej UI się pogubi
			inventory[i] = [item_name, item_quanity, item_descryption, item_category, item_variable]
		
			# Kluczowy krok: Powiadom UI o zmianie
			update_slot_visual(i, inventory[i][0], inventory[i][1], inventory[i][2], inventory[i][3], inventory[i][4])
			return

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	
	match slot.SlotType:
		SlotClass.SlotType.SHIRT or SlotClass.SlotType.PANTS or SlotClass.SlotType.SHOES or SlotClass.SlotType.SWORD:
			equips[slot.slot_index] = [item.item_name, item.item_quantity, item.item_descryption, item.item_category, item.item_variable]
		_:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity, item.item_descryption, item.item_category, item.item_variable]
	

func remove_item(slot: SlotClass):
	
	match slot.SlotType:
		SlotClass.SlotType.SHIRT or SlotClass.SlotType.PANTS or SlotClass.SlotType.SHOES or SlotClass.SlotType.SWORD:
			equips.erase(slot.slot_index)
		_:
			inventory.erase(slot.slot_index)
	
func add_item_quanity(slot: SlotClass, quanity_to_add: int):
	match slot.SlotType:
		SlotClass.SlotType.SHIRT or SlotClass.SlotType.PANTS or SlotClass.SlotType.SHOES or SlotClass.SlotType.SWORD:
			equips[slot.slot_index][1] += quanity_to_add
		_:
			inventory[slot.slot_index][1] += quanity_to_add

# PlayerInventory.gd

func update_slot_visual(slot_index, item_name, new_quantity, item_desc, item_cat, item_var):
	# Sprawdzamy, czy scena Inventory jest w ogóle otwarta
	if inventory_ui != null:
		# Tutaj precyzyjnie wskazujemy na GridContainer wewnątrz Twojej sceny
		var grid = inventory_ui.get_node("GridContainer") 
		var slots = grid.get_children()
		if slot_index < slots.size():
			var slot = slots[slot_index]
			if slot.item != null:
				slot.item.set_item(item_name, new_quantity, item_desc, item_cat, item_var)
			else:
				slot.initialize_item(item_name, new_quantity, item_desc, item_cat, item_var)
