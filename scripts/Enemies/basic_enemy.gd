extends Node2D
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export_enum("StoreManager", "Boss", "LordOrigami") var boss_type
@onready var area_2d: Area2D = $Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_in_battle = false

func _ready() -> void:
	SignalBus.battle_ended.connect(_battle_ended)
	match boss_type:
		0:
			animated_sprite_2d.play("StoreManager")
		1:
			animated_sprite_2d.play("Boss")
		2:
			animated_sprite_2d.play("LordOrigami")
	if GameProgressSaver.is_completed(self.name):
		area_2d.process_mode = Node.PROCESS_MODE_DISABLED
		self.visible = false
		is_in_battle = false
	
	
func _battle_ended(enemy_died: bool):
	if is_in_battle:
		area_2d.process_mode = Node.PROCESS_MODE_DISABLED
		is_in_battle = false
		if enemy_died:
			self.visible = false
			GameProgressSaver.mark_dialogue_as_done(self.name)
