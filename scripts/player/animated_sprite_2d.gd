extends AnimatedSprite2D

func on_change_orientation():
	self.flip_h = not self.flip_h
	
func on_play_animation(anim_name: String):
	play(anim_name)
