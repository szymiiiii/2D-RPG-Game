extends Node

const SlotClass = preload("res://scripts/Inventory/slot.gd")
const ItemClass = preload("res://scripts/Inventory/Item_script.tres.gd")
const NUM_INVENTORY_SLOTS = 24

var inventory = {
	0: ["Orange", 1, "d"],
	1: ["RedDiamond", 23, "d"],
	2: ["RedDiamond", 95, "d"]
}

var equips = {
	0: ["The Coat", 1, "d"],
	1: ["The Pants", 1, "d"],
	2: ["The Boots", 1, "d"],
}

func add_item(item_name, item_quanity, item_descryption):
	#print("add_item: ", item_name, ", quantity: ", item_quanity)
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quanity:
				inventory[item][1] += item_quanity
				update_slot_visual(item, inventory[item][0], inventory[item][1], inventory[item][2])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1], inventory[item][2])
				item_quanity = item_quanity - able_to_add
			#TODO Check if slot is full
			#inventory[item][1] += item_quanity
			#return
			
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quanity]
			update_slot_visual(i, inventory[i][0], inventory[i][1], inventory[i][2])
			return

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	
	match slot.SlotType:
		SlotClass.SlotType.SHIRT or SlotClass.SlotType.PANTS or SlotClass.SlotType.SHOES:
			equips[slot.slot_index] = [item.item_name, item.item_quantity]
		_:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity]
	

func remove_item(slot: SlotClass):
	
	match slot.SlotType:
		SlotClass.SlotType.SHIRT or SlotClass.SlotType.PANTS or SlotClass.SlotType.SHOES:
			equips.erase(slot.slot_index)
		_:
			inventory.erase(slot.slot_index)
	
func add_item_quanity(slot: SlotClass, quanity_to_add: int):
	match slot.SlotType:
		SlotClass.SlotType.SHIRT or SlotClass.SlotType.PANTS or SlotClass.SlotType.SHOES:
			equips[slot.slot_index][1] += quanity_to_add
		_:
			inventory[slot.slot_index][1] += quanity_to_add

func update_slot_visual(slot_index, item_name, new_quantity, item_descryption):
	var slot = get_tree().root.get_node("res://scenes/Inventory/Inventory/GridContainer/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity, item_descryption)
	else:
		slot.initialize_item(item_name, new_quantity)
