extends Node2D

#levele możliwe do przejscia dalej mozna je tu dodawac uzupełniając analogicznie opcje w enum i słowniku
enum Levels_Enum {one, two}
const LEVELS = {
	Levels_Enum.one: "res://scenes/Maps/level_one.tscn",
	Levels_Enum.two: "res://scenes/Maps/level_two.tscn",
}

#analogicznie jak wyzej ale nalezy brac pod uwage jakie animacje istnieja w loading screen
enum Transition_Enum {fade_to_black, fade_to_white, no_to_transition, wipe_to_right}
const TRANSITION_VALUES = {
	Transition_Enum.fade_to_black: "fade_to_black",
	Transition_Enum.fade_to_white: "fade_to_white",
	Transition_Enum.no_to_transition: "no_to_transition",
	Transition_Enum.wipe_to_right: "wipe_to_right",
}

@onready var collision_area = $Area2D
@onready var collision_shape = $Area2D/CollisionShape2D

#orientacja okreslajaca w jaki sposob gracz moze prowadzic interakcje z drzwiami
# i w jaka animacja zostanie wywolana w Player node
# w przypadku "vertical" musi najpierw nacisnac przycisk potwierdzajacy wejscie do nastepnej sceny
# w przypadku right i left wystarczy samo wejscie w drzwi
@export_enum("right", "left", "vertical") var orientation

#nastepna scena to scena mapy do zaladowania zamiast obecnej
@export var next_scene: Levels_Enum

#wybor przejscia uzywanego przez SceneManagera
@export var transition_choice: Transition_Enum

#wybor id, Player zostanie zespawnowany na nastepnej scenie przy drzwiach o tym samym numerze id
# w przypadku 
@export_range(0, 10) var id : int

func _ready() -> void:
	DoorManager.all_door_registrate_in_scene_manager.emit(self, id)
	print("drzwi ", id)

func _on_area_2d_body_entered(body: Node2D) -> void:
	var body_Name = body.name
	
	if (body_Name != "Player"):
		printerr("Doors.gd weszły w interakcje z wiezlem nie nazywajacym sie Player tylko: ", body_Name)
		printerr("dlatego wylaczam drzwi aby nie bylo problemow")
		collision_area.monitorable = false
	elif DoorManager.did_player_go_through_doors:
		print("Doors.gd weszło w interakcje z graczem ale przeszedl on juz przez drzwi")
	elif (orientation != null && next_scene != null && transition_choice != null && id != null):
		DoorManager.player_entered_doors.emit(id, orientation, TRANSITION_VALUES[transition_choice], LEVELS[next_scene], position)
		
		# UWAGA SceneManager zostanie wywolany w stanie GETTING_IN
		# jest to spowodowane tym ze gracz musi nacisnac najpierw odpowiedni przycisk stojac w drzwiach jesli jest wybrane vertical
		# oraz tym ze skrypt zakłada że player stojac na ziemii odtworzy inna animacje na ziemii i inna w powietrzu
		# takze wydaje mi sie ze latwiej to bedzie ogarnac w funkcji z delta w stanie gracza
		# plus nie umiem tego lepiej zaimplementowac xD
		
	else:
		printerr("nie uzupelnione wartosci drzwi: ", self.name)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if !DoorManager.did_player_go_through_doors:
		DoorManager.player_exited_doors.emit()
