extends GutTest

var Player = preload("res://unit_testing/Player_test.gd")
var Enemy = preload("res://unit_testing/Enemy_test.gd")
var enemy
var player

func before_each():
	player = Player.new()
	add_child(player)
	enemy = Enemy.new()
	add_child(enemy)

func after_each():
	player.queue_free()
	enemy.queue_free()
	
func test_player_damage():
	assert_eq(enemy.attack_player(player.curr_health), 90, "Player has taken damage")

func test_enemy_damage():
	assert_eq(player.attack_enemy(enemy.curr_health), 40, "Enemy has taken damage")

func test_player_defence():
	player.change()
	assert_eq(player.defend(enemy.attack), 95, "The player defended")

func test_enemy_poisoned():
	player.change()
	assert_eq(player.poisoned(enemy.curr_health), 10, "The enemy has been poisoned")

func test_enemy_bleeding():
	player.change()
	assert_eq(player.bleeding(enemy.curr_health), 20, "The enemy is bleeding")

func test_player_healing():
	var health = enemy.attack_player(player.curr_health)
	player.set_health(health)
	assert_eq(player.healing(), 98, "The player regained health")
