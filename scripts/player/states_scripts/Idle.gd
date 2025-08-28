extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	play_anim.emit("idle")

func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	
	if DoorManager.is_player_inside_vertical_doors && Input.is_action_pressed("ui_accept") || DoorManager.is_player_inside_horizontal_doors:
		finished.emit(GETTING_IN)
	elif not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("Jumping"):
		finished.emit(JUMPING)
	elif Input.is_action_pressed("Move_Left") or Input.is_action_pressed("Move_Right"):
		if Input.is_action_pressed("Running"):
			finished.emit(RUNNING)
		else:
			finished.emit(WALKING)
	
