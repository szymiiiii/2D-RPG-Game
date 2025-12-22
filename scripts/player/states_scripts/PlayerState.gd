class_name PlayerState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const WALKING = "Walking"
const GETTING_IN = "Getting_In"
const GETTING_OUT = "Getting_Out"

var player: Player


signal play_anim(animation_name)
signal change_orientation

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
