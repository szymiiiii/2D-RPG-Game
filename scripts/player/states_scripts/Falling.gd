extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	play_anim.emit("falling")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("Move_Left", "Move_Right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	
	if player.direction * input_direction_x < 0:
		player.direction *= -1
		change_orientation.emit(0)
	
	player.move_and_slide()

	if DoorManager.is_player_inside_vertical_doors && Input.is_action_pressed("Interact") || DoorManager.is_player_inside_horizontal_doors:
		finished.emit(GETTING_IN)
	elif player.is_on_floor():
		if is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		elif Input.is_action_pressed("Running"):
			finished.emit(RUNNING)
		else:
			finished.emit(WALKING)
