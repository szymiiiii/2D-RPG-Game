extends Node2D
@onready var day_one: Node2D = $DayOne
@onready var day_two: Node2D = $DayTwo
@onready var day_three: Node2D = $DayThree
@onready var with_friends: Node2D = $DayThree/WithFriends

func _ready() -> void:
	if !GameProgressSaver.is_completed("DayOne"):
		day_two.queue_free()
		day_three.queue_free()
	else:
		if !GameProgressSaver.is_completed("DayTwo"):
			day_one.queue_free()
			day_three.queue_free()
		else:
			day_one.queue_free()
			day_two.queue_free()
			if GameProgressSaver.is_completed("friends_with_anna") && GameProgressSaver.is_completed("friends_with_robert"):
				with_friends.visible = true
