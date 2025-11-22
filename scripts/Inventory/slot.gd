extends Panel

var taken = preload("res://assets/Items/Item_slot_taken.png")
var empty = preload("res://assets/Items/Item_slot.png")

var taken_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null

var ItemClass = preload("res://scenes/Inventory/Item.tscn")
var item = null

func _ready() -> void:
	taken_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	taken_style.texture = taken
	empty_style.texture = empty
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

func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()
