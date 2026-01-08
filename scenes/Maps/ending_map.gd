extends Node2D
@onready var ending_a: Area2D = $EndingA
@onready var with_friends: Node2D = $withFriends
@onready var player: Player = $Player
@onready var player_body_camera: Camera2D = $PlayerBodyCamera
var menu_interaction: FmodEvent = null

var has_ended: bool = false

func _ready() -> void:
	with_friends.visible = false
	if GlobalVariables.special_transition == true && SceneManager._loading_screen != null:
		DoorManager._clear_door_list()
		GlobalVariables.special_transition = false
		GlobalVariables.is_idle_forced = false
		player.reset_physics_interpolation()
		player_body_camera.reset_physics_interpolation()
		player_body_camera.make_current()
		SceneManager._loading_screen.finish_transition()
		
		# Wait or loading animation to finish
		await SceneManager._loading_screen.anim_player.animation_finished
	if GameProgressSaver.is_completed("LastQuestWithFriends"):
		with_friends.visible = true
		ending_a.queue_free()
	else:
		with_friends.queue_free()

func _process(delta: float) -> void:
	if !has_ended && (GameProgressSaver.is_completed("EndingB") || GameProgressSaver.is_completed("EndingA")):
		has_ended = true
		menu_interaction = FmodServer.create_event_instance("event:/menu event")
		menu_interaction.set_parameter_by_name("Reverb Mix", 0.8)
		menu_interaction.volume = 0.5
		SceneManager.swap_scenes("res://scenes/UI/Main_Menu.tscn" ,get_tree().root , self.get_parent().get_parent() ,"no_to_transition")
