extends Node

signal new_level
signal enemy_defeated

@export var player_level = 1
@export var current_exp = 0
@export var total = 30
@export var level_2 = 10
@export var level_3 = 20

func _ready() -> void:
	new_level.connect(level_up)
	enemy_defeated.connect(exp_get)

func level_up():
	if current_exp >= level_2 and player_level == 1:
		GlobalVariables.poison_sting == true
		player_level = 2
	elif current_exp >= level_3 and player_level == 2:
		GlobalVariables.sting_ray == true
		player_level = 3

func exp_get(exp: int):
	current_exp += exp
