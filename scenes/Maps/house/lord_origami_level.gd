extends Node2D
@onready var with_friends: Node2D = $Tilesets/WithFriends
var boss_defeated: bool = false

func _ready() -> void:
	if !GameProgressSaver.is_completed("LastQuestWithFriends"):
		with_friends.visible = false
		with_friends.queue_free()

func _process(delta: float) -> void:
	if !boss_defeated && GameProgressSaver.is_completed("LordOrigami"):
		boss_defeated = true
		SceneManager._add_loading_screen("fade_to_black")
		GlobalVariables.is_idle_forced = true
		await get_tree().create_timer(1).timeout
		GlobalVariables.special_transition = true
		SceneManager.swap_scenes("res://scenes/Maps/house/house_level.tscn", self.get_parent(), self, "no_transition")
