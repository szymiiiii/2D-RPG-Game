extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	play_anim.emit("falling")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	
	if direction * input_direction_x < 0:
		print(input_direction_x)
		print(direction)
		direction *= -1
		change_orientation.emit()
	
	player.move_and_slide()

	if player.is_on_floor():
		if is_equal_approx(input_direction_x, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
