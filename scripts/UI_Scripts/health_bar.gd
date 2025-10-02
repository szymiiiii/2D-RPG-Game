extends ProgressBar

@onready var scene = get_node(".")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if scene == get_node("root/Gameplay/Levels/Scena1/CanvasLayer/Hud/HealthBar"):
		var health: int = GlobalVariables.health
		value = health
		GlobalVariables.curr_health = value
	else:
		var health: int = GlobalVariables.curr_health
		value = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _health_up(delta: float) -> void:
	pass
