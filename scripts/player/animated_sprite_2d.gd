extends AnimatedSprite2D
	
	
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
	#print("zmieniam animacje na: ", anim_name)
	play(anim_name)
