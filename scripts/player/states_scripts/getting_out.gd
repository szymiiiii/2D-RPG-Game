extends PlayerState

var movement_direction_x: int
var is_player_on_ground: bool
var door_position_x
var door_position_y
var is_player_in_zone

func enter(previous_state_path: String, data := {}) -> void:
	#print("player got into getting OUT state")
	is_player_on_ground =player.is_on_floor()
	door_position_x = DoorManager.door_dictionary["door_position"].x
	door_position_y = DoorManager.door_dictionary["door_position"].y
	
	var door_orientation = DoorManager.door_dictionary["door_orientation"]
	
	if !is_player_on_ground:
		play_anim.emit("falling")
	elif door_orientation == 2:
		play_anim.emit("idle")
		movement_direction_x = 0
	else:
		play_anim.emit("walking")
		
	if door_orientation == 1:
		movement_direction_x = 1
	elif door_orientation == 0:
		movement_direction_x = -1
	
	if player.direction * movement_direction_x < 0:
		player.direction *= -1
		change_orientation.emit(0)
	
	
	

func physics_update(delta: float) -> void:
	#var input_direction_x := Input.get_axis("Move_Left", "Move_Right")
	
	#
	#if is_player_in_zone != (player.position.x <= door_position_x + 5 && player.position.x >= door_position_x - 5 ):
		#print("pozycja drzwi x: ", door_position_x, " i pozycja gracza x: ", player.position.x)
		#play_anim.emit("turn_around")
		#player.velocity.x = 0
		##is_player_in_zone = true
	#
	#if !is_player_in_zone:
		#
		#movement_direction_x = clamp(door_position_x - player.position.x, -1, 1) 
		#player.velocity.x = player.speed * movement_direction_x
		##print(movement_direction_x)
		#
		#if player.direction * movement_direction_x < 0:
			#player.direction *= -1
			#change_orientation.emit(0)
	if (player.position.x > door_position_x + 32 || player.position.x < door_position_x - 32 ):
		movement_direction_x = 0
	elif (player.position.y > door_position_y + 92 || player.position.y < door_position_y - 92 ):
		movement_direction_x = 0
		
	if is_player_on_ground != player.is_on_floor():
		if is_player_on_ground:
			play_anim.emit("falling")
		else:
			play_anim.emit("walking")
	player.velocity.x = player.speed * movement_direction_x
	player.velocity.y += player.gravity * delta
#
	player.move_and_slide()
	
	if DoorManager.door_dictionary["door_orientation"] == 2:
		#print("udalo sie wyjsc")
		DoorManager.did_player_go_through_doors = false
		
		finished.emit(IDLE)
		#get_tree().paused = true
		#print("pauza")
		#get_tree().create_timer(0.1).timeout
		#get_tree().paused = false
		#print("odpauzowanie")
	elif movement_direction_x == 0 || !DoorManager.did_player_go_through_doors:
		DoorManager.did_player_go_through_doors = false
		#await player.get_tree().create_timer(0.25).timeout
		#print("udalo sie wyjsc")
		if not player.is_on_floor():
			finished.emit(FALLING)
		elif Input.is_action_just_pressed("Jumping") && player.is_jumping_allowed:
			finished.emit(JUMPING)
		elif Input.is_action_pressed("Move_Left") or Input.is_action_pressed("Move_Right"):
			if Input.is_action_pressed("Running"):
				finished.emit(RUNNING)
			else:
				finished.emit(WALKING)
		else:
			finished.emit(IDLE)
		
	#if Input.is_action_pressed("ui_cancel"):
		#DoorManager.did_player_go_through_doors = false
		#finished.emit(IDLE)
