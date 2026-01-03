extends Node2D

##In case you want to add new level, just add new positions in Levels_Enum 
##and constant LEVELS in analogic way to whats below 
enum Levels_Enum {
	one, two, 
	
	house_entry, house_level, house_toilet, house_bedroom,
	
	path_one_two, office
	
	##Add new enum positions from below, so it wont break existing doors 
}
const LEVELS = {
	Levels_Enum.one: "res://scenes/Maps/level_one.tscn",
	Levels_Enum.two: "res://scenes/Maps/level_two.tscn",
	
	Levels_Enum.house_entry: "res://scenes/Maps/house/house_entry.tscn",
	Levels_Enum.house_level: "res://scenes/Maps/house/house_level.tscn",
	Levels_Enum.house_toilet: "res://scenes/Maps/house/house_toilet.tscn",
	Levels_Enum.house_bedroom: "res://scenes/Maps/house/house_bedroom.tscn",
	
	Levels_Enum.path_one_two: "res://scenes/Maps/level_1-2.tscn",
	Levels_Enum.office: "res://scenes/Maps/office.tscn",
}

##analogicznie jak wyzej ale nalezy brac pod uwage jakie animacje istnieja w loading screen
enum Transition_Enum {
	fade_from_black,
	fade_from_white,
	no_to_transition,
}
const TRANSITION_VALUES = {
	Transition_Enum.fade_from_black: "fade_from_black",
	Transition_Enum.fade_from_white: "fade_from_white",
	Transition_Enum.no_to_transition: "no_to_transition",
}

@onready var collision_area = $Area2D
@onready var collision_shape = $Area2D/CollisionShape2D

##orientacja okreslajaca w jaki sposob gracz moze prowadzic interakcje z drzwiami
## i jaka animacja zostanie wywolana w Player node
## w przypadku "vertical" musi najpierw nacisnac przycisk potwierdzajacy wejscie do nastepnej sceny
## w przypadku right i left wystarczy samo wejscie w drzwi
@export_enum("left", "right", "vertical") var orientation

##nastepna scena to scena mapy do zaladowania zamiast obecnej
@export var next_scene: Levels_Enum

##wybor przejscia uzywanego przez SceneManagera
@export var transition_choice: Transition_Enum

##wybor id, Player zostanie zespawnowany na nastepnej scenie przy drzwiach o tym samym numerze id
## w przypadku 
@export_range(0, 10) var id : int

@export var are_doors_closed: bool = false
var door_sound_event: FmodEvent = null

func _ready() -> void:
	DoorManager.all_door_registrate_in_scene_manager.emit(self, id)
	#print("drzwi ", id)

func _on_area_2d_body_entered(body: Node2D) -> void:
	var body_Name = body.name
	
	if (body_Name != "Player"):
		printerr("Doors.gd weszły w interakcje z wiezlem nie nazywajacym sie Player tylko: ", body_Name)
		printerr("dlatego wylaczam drzwi aby nie bylo problemow")
		collision_area.monitorable = false
	elif DoorManager.did_player_go_through_doors:
		pass
		#print("Doors.gd weszło w interakcje z graczem ale przeszedl on juz przez drzwi")
	elif are_doors_closed:
		print("drzwi som zamkniete")
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
