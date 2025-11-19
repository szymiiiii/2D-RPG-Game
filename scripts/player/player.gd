class_name Player extends CharacterBody2D
@onready var animation_player = $AnimatedSprite2D
@export var speed := 150.0
@export var gravity := 800.0
@export var jump_impulse := 400.0

@onready var state_machine = $State_Machine
@onready var animated_sprite = $AnimatedSprite2D



@export var direction = 1.0

func _ready():
	
	for state_node in state_machine.get_children():
		if state_node is PlayerState:
			state_node.play_anim.connect(animated_sprite.on_play_animation)
		
			state_node.change_orientation.connect(animated_sprite.on_change_orientation)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup"):
		print("pickup")
		if $PickupArea.items_in_range.size() > 0:
			print("action")
			var pickup_itme = $PickupArea.items_in_range.values()[0]
			pickup_itme.pick_up_item(self)
			$PickupArea.items_in_range.erase(pickup_itme)
