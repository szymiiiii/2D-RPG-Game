extends Node

var health: int = 100
var curr_health: int = 100
var attack: int = 2
var sword: int = 5
var defence: int = 5
var poison: int = 5
var bleed: int = 20
var resource: int = 8
var is_defece: bool = false

func attack_enemy(enemy_health: int):
	enemy_health = max(0, enemy_health - (attack*sword))
	return enemy_health

func defend(enemy_attach: int):
	if is_defece == true:
		curr_health = max(0, curr_health - (enemy_attach-defence))
		return curr_health
	return curr_health

func change():
	is_defece = !is_defece
	
func poisoned(enemy_health: int):
	for i in range(6):
		enemy_health = max(0, enemy_health - poison)
	return attack_enemy(enemy_health)

func bleeding(enemy_health: int):
	enemy_health = max(0, enemy_health - bleed)
	return attack_enemy(enemy_health)

func healing():
	curr_health = min(health, curr_health+resource)
	return curr_health

func set_health(health: int):
	curr_health = health
