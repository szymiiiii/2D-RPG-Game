extends Node

const SAVE_PATH = "user://globalVariables.tres"

func save_game():
	var data = GlobalVar.new()
	data.curr_health = curr_health
	
	var result = ResourceSaver.save(data, SAVE_PATH)
	if result == OK:
		print("Gra zapisana pomyślnie!")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("Brak pliku zapisu.")
		return

	var data = ResourceLoader.load(SAVE_PATH) as GlobalVar
	if data:
		curr_health = data.curr_health

#szymi
signal player_ready(Player)

var is_continue_enabled = false
var has_dialog_started = false
var is_idle_forced = false
var is_in_battle = false
var cur_enemy = 0
var special_transition = false

##Zastąpiłem zmienną friendship systemem z GameProgressSaver
#var friends_with_anna = GameProgressSaver.is_completed("friends_with_anna")
#var friends_with_robert = GameProgressSaver.is_completed("friends_with_robert")
#GameProgressSaver.mark_dialogue_as_done("friends_with_anna")

#Janek

@onready var battle = preload("res://scenes/Battle/Battle1.tscn")

#Janek
@export var player_name = "Player"
@export var player_shirt = 0
@export var player_pants = 0
@export var player_boots = 0

@export var health: int = 100
@export var curr_health: int = 100
@export var attack_power: int = 4
@export var sword: int = 20
@export var fireball: bool = true
@export var poison_sting: bool = true
@export var sting_ray: bool = true
@export var penguin: String = ""

@export var f_name: String = "Fireball"
@export var f_effect: int = 0
@export var f_damage: int = 25
@export var f_time: int = 0
@export var f_cost: int = 25

@export var p_name: String = "PoisonShot"
@export var p_effect: int = 5
@export var p_damage: int = 10
@export var p_time: int = 2
@export var p_cost: int = 10

@export var b_name: String = "StingRay"
@export var b_effect: int = 20
@export var b_damage: int = 20
@export var b_time: int = 15
@export var b_cost: int = 15

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_dialogue_started)
	DialogueManager.dialogue_ended.connect(_dialogue_ended)

func _set_health() -> void:
	#if first == false:
		pass
		
		
func _dialogue_started(resource: DialogueResource) -> void:
	#print("dialgoue started")
	has_dialog_started = true
	is_idle_forced = true
	pass
	
func _dialogue_ended(resource: DialogueResource) -> void:
	has_dialog_started = false
	is_idle_forced = false
	if is_in_battle == true:
		SignalBus.is_in_battle.emit()
	pass
