extends Node2D
@onready var boss_actionable_day_one: Area2D = $BossActionableDayOne
@onready var got_the_ink: Area2D = $GotTheInk

func _ready() -> void:
	if GameProgressSaver.is_completed("GotPrinterInk"):
		got_the_ink.monitorable = true
		got_the_ink.monitoring = true
		boss_actionable_day_one.monitorable = false
		boss_actionable_day_one.monitoring = false
	else: 
		got_the_ink.monitorable = false
		got_the_ink.monitoring = false
		boss_actionable_day_one.monitorable = true
		boss_actionable_day_one.monitoring = true
