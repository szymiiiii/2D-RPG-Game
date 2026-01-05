extends Area2D

const Balloon = preload("res://dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var automatic_interaction: bool = false

##If this is true remember to give this node UNIQUE NAME
@export var can_be_completed: bool = false
var ongoing: bool = false

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_dialogue_ended)
	if can_be_completed && GameProgressSaver.is_completed(self.name):
		process_mode = Node.PROCESS_MODE_DISABLED

func action() -> void:
	#print("ballon started", !GlobalVariables.has_dialog_started)
	if !ongoing && !GameProgressSaver.is_completed(self.name) && !GlobalVariables.has_dialog_started :
		DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
		print("odpaliło się action")
		ongoing = true
	#var bal: Node = Balloon.instantiate()
	#bal.start(dialogue_resource, dialogue_start)


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if !ongoing && automatic_interaction && !GlobalVariables.has_dialog_started:
		if !GameProgressSaver.is_completed(self.name) && !GlobalVariables.has_dialog_started :
			DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
			#print("odpaliło się _on_area_shape_entered")
			ongoing = true
			
			
func _dialogue_ended(resource: DialogueResource):
	if ongoing == true:
		mark_as_done()
		ongoing = false
			
func mark_as_done():
	if can_be_completed:
		if self.name == "AniaIntroduction":
			#print("a")
			if GameProgressSaver.is_completed("friends_with_anna"):
				#print("b")
				GameProgressSaver.mark_dialogue_as_done(self.name)
		else:
			GameProgressSaver.mark_dialogue_as_done(self.name)
