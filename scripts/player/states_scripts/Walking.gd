extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	play_anim.emit("walking")
	
func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("ui_left", "ui_right")
	player.velocity.x = 1.3 * player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	
	if direction * input_direction_x < 0:
		print(input_direction_x)
		print(direction)
		direction *= -1
		change_orientation.emit()
	
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("ui_up"):
		finished.emit(JUMPING)
	elif is_equal_approx(input_direction_x, 0.0):
		finished.emit(IDLE)
