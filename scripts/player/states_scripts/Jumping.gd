extends PlayerState

var counter = 0

func enter(previous_state_path: String, data := {}) -> void:
	counter = 0
	player.velocity.y = -(player.jump_impulse / 5 * 4 )
	play_anim.emit("jumping")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("Move_Left", "Move_Right")
	
	if counter < 10:
		player.velocity.y -= player.jump_impulse/50
		counter += 1
	player.velocity.x = player.speed * input_direction_x
	player.velocity.y += player.gravity * delta
	
	#print(player.velocity.y)
	if Input.is_action_just_released("Jumping") || GlobalVariables.is_idle_forced:
		player.velocity.y = player.velocity.y/3
		
	if player.direction * input_direction_x < 0:
		player.direction *= -1
		change_orientation.emit(0)
	
	player.move_and_slide()
	
	if DoorManager.is_player_inside_vertical_doors && Input.is_action_pressed("Interact") || DoorManager.is_player_inside_horizontal_doors:
		finished.emit(GETTING_IN)
	elif player.velocity.y >= 0:
		finished.emit(FALLING)
