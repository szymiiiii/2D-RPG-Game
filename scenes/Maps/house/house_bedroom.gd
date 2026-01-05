extends Node2D
@onready var day_one: Node2D = $DayOne
@onready var day_two: Node2D = $DayTwo
@onready var day_three: Node2D = $DayThree

@onready var day_one_completion: Area2D = $DayOne/DayOneCompletion
@onready var day_two_completion: Area2D = $DayTwo/DayTwoCompletion

@onready var player: Player = $Player
@onready var player_body_camera: Camera2D = $Player/PlayerBodyCamera
var ending_reached = false

func _ready() -> void:
	if !GameProgressSaver.is_completed("DayOne"):
		day_two.queue_free()
		day_three.queue_free()
		if GameProgressSaver.is_completed("GotTheInk"):
			day_one_completion.monitorable = true
			day_one_completion.monitoring = true
	else:
		if !GameProgressSaver.is_completed("DayTwo"):
			day_one.queue_free()
			day_three.queue_free()
			if GameProgressSaver.is_completed("OfficeBossEnemy") || GameProgressSaver.is_completed("BossCafeWithRobert"):
				day_two_completion.monitorable = true
				day_two_completion.monitoring = true
		else:
			if !GameProgressSaver.is_completed("LordOrigami"):
				day_three.queue_free()
			day_one.queue_free()
			day_two.queue_free()
		


func _process(delta: float) -> void:
	if GameProgressSaver.is_completed("DayOneCompletion") && !GameProgressSaver.is_completed("DayOne"):
		GameProgressSaver.mark_dialogue_as_done("DayOne")
		_make_transition()
	if GameProgressSaver.is_completed("DayTwoCompletion") && !GameProgressSaver.is_completed("DayTwo"):
		GameProgressSaver.mark_dialogue_as_done("DayTwo")
		_make_transition()
	if !ending_reached && GameProgressSaver.is_completed("EndingWithOutFriends") :
		ending_reached = true
		SceneManager._add_loading_screen("fade_to_black")
		GlobalVariables.is_idle_forced = true
		await get_tree().create_timer(1).timeout
		GlobalVariables.special_transition = true
		SceneManager.swap_scenes("res://scenes/Maps/ending_map.tscn", self.get_parent(), self, "no_transition")
		
func _make_transition():
	SceneManager._add_loading_screen("fade_to_black")
	GlobalVariables.is_idle_forced = true
	await get_tree().create_timer(1).timeout
		
	if SceneManager._loading_screen != null:
		SceneManager._loading_screen.finish_transition()
		
		# Wait or loading animation to finish
		await SceneManager._loading_screen.anim_player.animation_finished
	GlobalVariables.is_idle_forced = false
		
