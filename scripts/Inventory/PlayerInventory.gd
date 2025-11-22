extends Node

const NUM_INVENTORY_SLOTS = 24

var inventory = {
	0: ["Orange", 1]
}

func add_item(item_name, item_quanity):
	for item in inventory:
		if inventory[item][0] == item_name:
			#TODO Check if slot is full
			inventory[item][1] += item_quanity
			return
			
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quanity]
			return
