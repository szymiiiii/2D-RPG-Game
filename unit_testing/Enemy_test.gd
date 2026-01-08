extends Node

var health: int = 50
var curr_health: int = 50
var attack: int = 10

func attack_player(player_health: int):
	player_health = max(0, player_health-attack)
	return player_health
