extends ProgressBar

@onready var scene = get_node(".")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = GlobalVariables.health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _health_up(delta: float) -> void:
	pass
