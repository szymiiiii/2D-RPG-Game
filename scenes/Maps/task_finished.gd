extends Node2D
@onready var got_printer_ink: Area2D = $GotPrinterInk

func _ready() -> void:
	got_printer_ink.monitorable = false
	got_printer_ink.monitoring = false

func _process(delta: float) -> void:
	if GameProgressSaver.is_completed("GotPrinterInk") && visible:
		visible = false
	if !got_printer_ink.monitorable && !GameProgressSaver.is_completed("GotPrinterInk") && (GameProgressSaver.is_completed("SuperMarketBoss") || GameProgressSaver.is_completed("StoreMangerWithFriends")):
		got_printer_ink.monitorable = true
		got_printer_ink.monitoring = true
