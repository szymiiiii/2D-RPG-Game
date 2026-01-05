extends Node2D
@onready var wall: Node2D = $DayOne/Wall
@onready var wall_layer: TileMapLayer = $DayOne/Wall/WallLayer
@onready var house_doors: Node2D = $HouseDoors
@onready var coffee_doors: Node2D = $CoffeeDoors
@onready var shop_doors: Node2D = $ShopDoors
@onready var office_doors: Node2D = $OfficeDoors

@onready var day_one: Node2D = $DayOne
@onready var day_two: Node2D = $DayTwo
@onready var day_three: Node2D = $DayThree

@onready var robert: Node2D = $DayTwo/Robert
@onready var robert_day_two_end: Area2D = $DayTwo/Robert/RobertDayTwoEnd

@onready var ania_friendship: Node2D = $DayOne/Ania
@onready var ania_introduction: Area2D = $DayOne/Ania/AniaIntroduction

@onready var ania_day_one: Node2D = $AniaDayOne
@onready var ania_end_of_a_day: Area2D = $AniaDayOne/AniaEndOfADay

var is_wall_active: bool

func _ready() -> void:
	robert.visible = false
	robert_day_two_end.monitorable = false
	robert_day_two_end.monitoring = false
	
	ania_day_one.visible = false
	ania_end_of_a_day.monitorable = false
	ania_end_of_a_day.monitoring = false
	
	if !GameProgressSaver.is_completed("DayOne"):
		day_two.queue_free()
		day_three.queue_free()
		is_wall_active = wall != null
		if is_wall_active && GameProgressSaver.is_completed("BossActionableDayOne"):
			wall.queue_free()
			is_wall_active = false
		if GameProgressSaver.is_completed("BossActionableDayOne"):
			house_doors.set("are_doors_closed", true)
			coffee_doors.set("are_doors_closed", true)
		if GameProgressSaver.is_completed("SuperMarketBoss"):
			ania_friendship.visible = false
			ania_introduction.monitorable = false
			ania_end_of_a_day.monitoring = false
		if GameProgressSaver.is_completed("GotTheInk"):
			house_doors.set("are_doors_closed", false)
			office_doors.set("are_doors_closed", true)
			coffee_doors.set("are_doors_closed", true)
			shop_doors.set("are_doors_closed", true)
			
			if GameProgressSaver.is_completed("friends_with_anna"):
					ania_day_one.visible = true
					ania_end_of_a_day.monitorable = true
					ania_end_of_a_day.monitoring = true
	else:
		if !GameProgressSaver.is_completed("DayTwo"):
			day_one.queue_free()
			day_three.queue_free()
			house_doors.set("are_doors_closed", true)
			office_doors.set("are_doors_closed", false)
			coffee_doors.set("are_doors_closed", true)
			shop_doors.set("are_doors_closed", true)
			if GameProgressSaver.is_completed("DayTwoQuest"):
				coffee_doors.set("are_doors_closed", false)
			if GameProgressSaver.is_completed("OfficeBossEnemy") || GameProgressSaver.is_completed("BossCafeWithRobert"):
				coffee_doors.set("are_doors_closed", true)
				office_doors.set("are_doors_closed", true)
				house_doors.set("are_doors_closed", false)
				if GameProgressSaver.is_completed("friends_with_robert"):
					robert.visible = true
					robert_day_two_end.monitorable = true
					robert_day_two_end.monitoring = true
		else:
			day_one.queue_free()
			day_two.queue_free()
			house_doors.set("are_doors_closed", true)
			office_doors.set("are_doors_closed", false)
			coffee_doors.set("are_doors_closed", true)
			shop_doors.set("are_doors_closed", true)
			if GameProgressSaver.is_completed("DayThreeQuest"):
				coffee_doors.set("are_doors_closed", true)
				office_doors.set("are_doors_closed", true)
				house_doors.set("are_doors_closed", false)
