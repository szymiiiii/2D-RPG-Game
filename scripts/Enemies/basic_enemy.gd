extends Node2D
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@onready var area_2d: Area2D = $Area2D

var is_in_battle = false

func _ready() -> void:
	SignalBus.battle_ended.connect(_battle_ended)
	
func _battle_ended():
	if is_in_battle:
		area_2d.process_mode = Node.PROCESS_MODE_DISABLED
		self.visible = false
		is_in_battle = false
