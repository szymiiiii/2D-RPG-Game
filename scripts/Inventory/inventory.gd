extends Control

const SlotClass = preload("res://scripts/Inventory/slot.gd")
@onready var invent_slots = $GridContainer
@onready var equip_slots = $EquipSlots
var holding_item = null
var descryption = preload("res://scenes/Inventory/Descryption.tscn")

func _ready() -> void:
	var slots = invent_slots.get_children()
	var e_slots = equip_slots.get_children()
	for s in range(slots.size()):
		slots[s].gui_input.connect(slot_gui_input.bind(slots[s]))
		slots[s].slot_index = s
		slots[s].slotType = SlotClass.SlotType.ITEMS
	for i in range(e_slots.size()):
		e_slots[i].gui_input.connect(slot_gui_input.bind(e_slots[i]))
		e_slots[i].slot_index = i
	e_slots[0].slotType = SlotClass.SlotType.SHIRT
	e_slots[1].slotType = SlotClass.SlotType.PANTS
	e_slots[2].slotType = SlotClass.SlotType.SHOES
	initialize_inventory()
	initialize_equips()
		
func initialize_inventory():
	var slots = invent_slots.get_children()
	for i in range(slots.size()):
		if PlayerInventory.inventory.has(i):
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1], PlayerInventory.inventory[i][2], PlayerInventory.inventory[i][3], PlayerInventory.inventory[i][4])

func initialize_equips():
	var e_slots = equip_slots.get_children()
	for i in range(e_slots.size()):
		if PlayerInventory.equips.has(i):
			e_slots[i].initialize_item(PlayerInventory.equips[i][0], PlayerInventory.equips[i][1], PlayerInventory.inventory[i][2], PlayerInventory.inventory[i][3], PlayerInventory.inventory[i][4])

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if holding_item != null:
				if !slot.item:
					left_click_empty(slot)
				else:
					# Different item, so swap
					if holding_item.item_name != slot.item.item_name:
						left_click_diff_item(event, slot)
					# Same item, so try to merge
					else:
						left_click_same_item(slot)
			elif slot.item:
				left_click_not_holding(slot)
		elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
			if holding_item == null:
				if slot.item:
					#slot.descryption_instance.position = Vector2(10,10)
					#inv.add_child(slot.descryption_instance)
					slot.hovering_started.emit()
					slot.hovering_ended.emit()
					#holding_item = slot.descryption_instance

func _input(event: InputEvent) -> void:
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func able_to_put_into_slot(slot: SlotClass):
	if holding_item == null:
		return true
	var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCategory"]
	return true

func left_click_empty(slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(holding_item, slot)
		slot.putIntoSlot(holding_item)
		holding_item = null
	
func left_click_diff_item(event: InputEvent, slot: SlotClass):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(holding_item)
		holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	if able_to_put_into_slot(slot):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= holding_item.item_quantity:
			PlayerInventory.add_item_quanity(slot, holding_item.item_quanity)
			slot.item.add_item_quantity(holding_item.item_quantity)
			holding_item.queue_free()
			holding_item = null
		else:
			PlayerInventory.add_item_quanity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add)
			holding_item.decrease_item_quantity(able_to_add)

func left_click_not_holding(slot: SlotClass):
	PlayerInventory.remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()


func _on_slot_mouse_entered(slot: SlotClass) -> void:
	slot.hovering_started.emit(self)


func _on_slot_mouse_exited(slot: SlotClass) -> void:
	slot.hovering_ended.emit(self)
