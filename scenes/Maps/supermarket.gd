extends Node2D
@onready var with_friends: Node2D = $WithFriends
@onready var friendless: Node2D = $Friendless

func _ready() -> void:
	#print(GameProgressSaver.is_completed("friends_with_anna"))
	if GameProgressSaver.is_completed("friends_with_anna"):
		friendless.queue_free()
	else:
		with_friends.queue_free()
