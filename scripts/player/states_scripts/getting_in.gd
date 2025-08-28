extends PlayerState

var movement_direction_x: int
var is_player_on_ground: bool
var door_position_x
var is_player_in_zone

func enter(previous_state_path: String, data := {}) -> void:
	is_player_on_ground =player.is_on_floor()
	door_position_x = DoorManager.door_dictionary["door_position"].x
	is_player_in_zone = player.position.x <= door_position_x + 5 && player.position.x >= door_position_x - 5
	
	if is_player_in_zone:
		DoorManager.player_ready_to_pass.emit(0.5)
		play_anim.emit("turn_around")
	else:
		DoorManager.player_ready_to_pass.emit(0.3)
		if is_player_on_ground:
			play_anim.emit("walking")
		else:
			play_anim.emit("falling")
	pass

func physics_update(delta: float) -> void:
	#var input_direction_x := Input.get_axis("Move_Left", "Move_Right")
	
	
	if is_player_in_zone != (player.position.x <= door_position_x + 5 && player.position.x >= door_position_x - 5 ):
		print("pozycja drzwi x: ", door_position_x, " i pozycja gracza x: ", player.position.x)
		play_anim.emit("turn_around")
		player.velocity.x = 0
		is_player_in_zone = true
	
	if !is_player_in_zone:
		
		movement_direction_x = clamp(door_position_x - player.position.x, -1, 1) 
		player.velocity.x = player.speed * movement_direction_x
		#print(movement_direction_x)
		
		if player.direction * movement_direction_x < 0:
			player.direction *= -1
			change_orientation.emit(0)
		if is_player_on_ground != player.is_on_floor():
			play_anim.emit("walking")
	
	player.velocity.y += player.gravity * delta

	player.move_and_slide()

	#uzywalem tego przy drzwiach wertykalnych jak nie bylo dzialajacej zmiany sceny
	#if Input.is_action_pressed("ui_cancel"):
		#finished.emit(IDLE)
	
