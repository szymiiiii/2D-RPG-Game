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
var item_name
@export var item_choice: Item_Enum

func _ready() -> void:
	item_name = ITEM_VALUES[item_choice]

func _physics_process(delta):
	if being_picked_up == false:
		velocity = velocity.move_toward(Vector2(0, MAX_SPEED), ACCELERATION * delta)
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		var distance = global_position.distance_to(player.global_position)
		if distance < 4:
			PlayerInventory.add_item(item_name, 1)
			queue_free()
	#velocity = move_and_slide()

func pick_up_item(body):
	player = body
	being_picked_up = true
