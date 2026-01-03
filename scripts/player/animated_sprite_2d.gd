extends AnimatedSprite2D
	
var frame_counter: int = 0
var frames_count: int = 7
var walking_sound: FmodEvent = null
var falling_sound: FmodEvent = null
var jumping_sound: FmodEvent = null

func _ready():
	walking_sound = FmodServer.create_event_instance("event:/walking")
	walking_sound.volume = 1.5
	falling_sound = FmodServer.create_event_instance("event:/falling")
	falling_sound.volume = 1.5
	jumping_sound = FmodServer.create_event_instance("event:/jumping")
	jumping_sound.volume = 1.5

func on_change_orientation(set_value_or_mirror: int):
	###W GODOCIE FLIP_H JAKO TRUE TO ODWRÓCONY STAN A FALSE NORMALNY
	###dlatego podmieniłem 1 jako false a -1 jako true
	### 0 po prostu podmienia wartość pod przeciwną
	if set_value_or_mirror == 0:
		#print("gracz anim - zmieniam orientacje")
		self.flip_h = not self.flip_h
	elif set_value_or_mirror == -1:
		#print("gracz anim - ustawiam orientacje na true")
		self.flip_h = true
	elif set_value_or_mirror == 1:
		#print("gracz anim - ustawiam orientacje na false")
		self.flip_h = false
	else:
		printerr("gracz anim - funkcja on_change_orientation arg poza przeddzialem (-1,1)")
		
	
	
func on_play_animation(anim_name: String):
	await get_tree().create_timer(0.05).timeout
	#print("animacja ", animation.get_basename(), " przechodzi w ", anim_name)
	if animation.get_basename() == "falling":
		falling_sound.start()
	if anim_name == "jumping":
		jumping_sound.start()
	play(anim_name)
	
	frames_count = sprite_frames.get_frame_count(anim_name)

func _process(delta: float) -> void:
	if frame_counter % frames_count == 0:
		#print(frame)
		if (animation.get_basename() == "walking" || animation.get_basename() == "running") && (frame == 0 || frame == 3):
			walking_sound.start()
	frame_counter += 1
