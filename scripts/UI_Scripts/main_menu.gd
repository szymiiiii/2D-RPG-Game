extends Control
#
#var ost_event: FmodEvent = null


func _ready():
	pass
	#ost_event = FmodServer.create_event_instance("event:/main menu")
	#ost_event.volume = 1
	#
	#ost_event.start()
	#
	#SceneManager.start_swapping.connect(_stop_event)
	#
#func _stop_event():
	#while(ost_event.volume > 0):
		#ost_event.volume -= 0.5
		#await get_tree().create_timer(0.01).timeout
	##print("event stop")
	#ost_event.stop(3)
	#ost_event.release()
	#
	#
