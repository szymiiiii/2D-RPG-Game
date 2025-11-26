class_name Player extends CharacterBody2D
@onready var animation_player = $AnimatedSprite2D
@export var speed := 150.0
@export var gravity := 800.0
@export var jump_impulse := 400.0
@export var is_jumping_allowed := true

@onready var state_machine = $State_Machine
@onready var animated_sprite = $AnimatedSprite2D
@onready var actionable_finder: Area2D = $ActionableFinder

@export var direction = 1.0

func _ready():
	#print("player ready")
	
	for state_node in state_machine.get_children():
		if state_node is PlayerState:
			state_node.play_anim.connect(animated_sprite.on_play_animation)
		
			state_node.change_orientation.connect(animated_sprite.on_change_orientation)
	#print("player has spawned and is ready")
	#reset_physics_interpolation()
	DoorManager.player_ready_to_teleport_to_door.connect(self._on_ready_to_teleport_to_door)
	DoorManager.player_ready.emit()

func _on_ready_to_teleport_to_door():
	var teleport_position = DoorManager.door_dictionary["door_position"]
	self.position.x = teleport_position.x
	self.position.y = teleport_position.y + 32
	#print("player physics reset")
	reset_physics_interpolation()

#Janek MERGE
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pickup"):
		print("pickup")
		if $PickupArea.items_in_range.size() > 0:
			print("action")
			var pickup_itme = $PickupArea.items_in_range.values()[0]
			pickup_itme.pick_up_item(pickup_itme)
			$PickupArea.items_in_range.erase(pickup_itme)
	elif event.is_action_pressed("Interact"):
		var action = actionable_finder.get_overlapping_areas()
		if action.size() > 0:
			action[0].action()
