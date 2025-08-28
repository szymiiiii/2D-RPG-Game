extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = -player.jump_impulse
	play_anim.emit("jumping")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("Move_Left", "Move_Right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	
	if player.direction * input_direction_x < 0:
		player.direction *= -1
		change_orientation.emit(0)
	
	player.move_and_slide()
	
	if DoorManager.is_player_inside_vertical_doors && Input.is_action_pressed("ui_accept") || DoorManager.is_player_inside_horizontal_doors:
		finished.emit(GETTING_IN)
	elif player.velocity.y >= 0:
		finished.emit(FALLING)
