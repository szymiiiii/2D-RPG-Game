extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = -player.jump_impulse
	play_anim.emit("jumping")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	
	if direction * input_direction_x < 0:
		print(input_direction_x)
		print(direction)
		direction *= -1
		print("jump")
		change_orientation.emit()
	
	player.move_and_slide()

	if player.velocity.y >= 0:
		finished.emit(FALLING)
