class_name Player extends CharacterBody2D
@onready var animation_player = $AnimatedSprite2D
@export var speed := 150.0
@export var gravity := 800.0
@export var jump_impulse := 400.0

@onready var state_machine = $State_Machine
@onready var animated_sprite = $AnimatedSprite2D
func _ready():
	for state_node in state_machine.get_children():
		if state_node is PlayerState:
			state_node.play_anim.connect(animated_sprite.on_play_animation)
		
			state_node.change_orientation.connect(animated_sprite.on_change_orientation)
