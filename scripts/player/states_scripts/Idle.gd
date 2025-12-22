extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.x = 0.0
	play_anim.emit("idle")

func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.move_and_slide()
	
	if GlobalVariables.is_idle_forced:
		pass
	elif DoorManager.is_player_inside_vertical_doors && Input.is_action_pressed("Interact") || DoorManager.is_player_inside_horizontal_doors:
		finished.emit(GETTING_IN)
	elif not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("Jumping") && player.is_jumping_allowed:
		finished.emit(JUMPING)
	elif Input.is_action_pressed("Move_Left") or Input.is_action_pressed("Move_Right"):
		if Input.is_action_pressed("Running"):
			finished.emit(RUNNING)
		else:
			finished.emit(WALKING)
	
