extends Node2D

@onready var day_one: Node2D = $DayOne
@onready var day_two: Node2D = $DayTwo
@onready var day_three: Node2D = $DayThree
@onready var friendless: Node2D = $DayTwo/Friendless
@onready var with_friends: Node2D = $DayTwo/WithFriends
@onready var should_go_home_cafe: Area2D = $DayTwo/Friendless/ShouldGoHomeCafe
var is_boss_defeated: bool = false

func _ready() -> void:

	if !GameProgressSaver.is_completed("DayOne"):
		day_two.queue_free()
		day_three.queue_free()
	else:
		if !GameProgressSaver.is_completed("DayTwo"):
			day_one.queue_free()
			day_three.queue_free()
			if GameProgressSaver.is_completed("friends_with_robert"):
				friendless.queue_free()
			else:
				should_go_home_cafe.monitorable = false
				should_go_home_cafe.monitoring = false
				with_friends.queue_free()
		else:
			day_one.queue_free()
			day_two.queue_free()
			
func _process(delta: float) -> void:
	if !is_boss_defeated && GameProgressSaver.is_completed("OfficeBossEnemy") && GameProgressSaver.is_completed("DayOne") && !GameProgressSaver.is_completed("DayTwo"):
		is_boss_defeated = true
		should_go_home_cafe.monitorable = true
		should_go_home_cafe.monitoring = true
		
