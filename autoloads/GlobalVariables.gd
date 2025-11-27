extends Node

#szymi
signal player_ready(Player)

var is_continue_enabled = false
var has_dialog_started = false
var is_idle_forced = false
var is_in_battle = false

#Janek
@export var health: int = 100
@export var curr_health: int = 50
@export var attack_power: int = 5
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
