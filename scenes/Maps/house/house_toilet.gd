extends Node2D

@onready var house_toilet_drop_one: Area2D = $DayOne/HouseToiletDropOne
@onready var house_toilet_drop_two: Area2D = $DayOne/HouseToiletDropTwo
@onready var house_toilet_tutorial: Area2D = $DayOne/HouseToiletTutorial
@onready var day_two_toilet_drop_one: Area2D = $DayTwo/DayTwoToiletDropOne
@onready var day_two_toilet_drop_two: Area2D = $DayTwo/DayTwoToiletDropTwo
@onready var day_three_toilet_drop_one: Area2D = $DayThree/DayThreeToiletDropOne
@onready var day_three_toilet_drop_two: Area2D = $DayThree/DayThreeToiletDropTwo


@onready var day_one: Node2D = $DayOne
@onready var day_two: Node2D = $DayTwo
@onready var day_three: Node2D = $DayThree

func _ready() -> void:
	if_is_completed_remove(house_toilet_drop_one)
	if_is_completed_remove(house_toilet_drop_two)
	if_is_completed_remove(day_two_toilet_drop_one)
	if_is_completed_remove(day_two_toilet_drop_two)
	if_is_completed_remove(day_three_toilet_drop_one)
	if_is_completed_remove(day_three_toilet_drop_two)
	
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
		

func if_is_completed_remove(item_drop: Area2D):
		if GameProgressSaver.is_completed(item_drop.name):
			item_drop.queue_free()

func _process(delta: float) -> void:
	if !GameProgressSaver.is_completed("DayOne"):
		if !house_toilet_tutorial.monitorable && GameProgressSaver.is_completed("HouseToiletDropTwo"):
			house_toilet_tutorial.monitorable = true
			house_toilet_tutorial.monitoring = true
	else:
		if !GameProgressSaver.is_completed("DayTwo"):
			pass
		else:
			pass
