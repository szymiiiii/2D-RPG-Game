extends Area2D

var player = null
var being_picked_up = false

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO

##TRZEBA BRAĆ POD UWAGĘ JAKIE PRZEDMIOTY SĄ W ITEMDATA.JSON
enum Item_Enum {
	RedDiamond,
	Orange,
}
const ITEM_VALUES = {
	Item_Enum.RedDiamond: "RedDiamond",
	Item_Enum.Orange: "Orange",
	
}
const ITEM_DESCRYPTION = {
	Item_Enum.RedDiamond: "A stone that's coloured red. That's all.",
	Item_Enum.Orange: "Refreshing. Restores 20 HP."
}
var item_name
var item_descryption
var item_category
var item_variable
@export var item_choice: Item_Enum

func _ready() -> void:
	item_name = ITEM_VALUES[item_choice]
	item_descryption = ITEM_DESCRYPTION[item_choice]
	item_category = str(JsonData.item_data[item_choice]["ItemCategory"])
	item_variable = int(JsonData.item_data[item_choice]["ItemVariable"])
func _physics_process(delta):
	if being_picked_up == false:
		velocity = velocity.move_toward(Vector2(0, MAX_SPEED), ACCELERATION * delta)
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 4:
			PlayerInventory.add_item(item_name, 1, item_descryption, item_category, item_variable)
			queue_free()
	#velocity = move_and_slide()

func pick_up_item(body):
	player = body
	being_picked_up = true
