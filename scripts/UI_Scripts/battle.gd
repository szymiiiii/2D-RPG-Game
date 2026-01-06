extends Control

signal item_press
signal text_closed
signal death
var enemy: Resource = null
var player_health = GlobalVariables.curr_health
@export var e_health: int
@export var e_exp: int
const InventoryClass = preload("res://scripts/Inventory/PlayerInventory.gd")
const ItemClass = preload("res://scripts/Inventory/Item_script.tres.gd")
@onready var button = preload("res://scenes/Battle/Button1.tscn")
var starting

func _ready() -> void:
	#SignalBus.is_in_battle.connect(_player_joins_battle)

	visible = true
	_player_joins_battle()
	
func _input(event) -> void:
	if (Input.is_action_just_pressed("Interact") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("text_closed")

func set_health(progress_bar, health, max_health) -> void:
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]

func healing_item():
	set_health($PlayerPanel/HBoxContainer/ProgressBar, GlobalVariables.curr_health, GlobalVariables.health)

func show_text(text):
	$Textbox.show()
	$Textbox/Label.text = text

func enemy_turn() -> void:
	show_text("%s charges at you" % enemy.name)
	await text_closed
	GlobalVariables.curr_health = max(0, GlobalVariables.curr_health - (enemy.damage-(GlobalVariables.player_shirt*GlobalVariables.player_pants*GlobalVariables.player_boots)))
	set_health($PlayerPanel/HBoxContainer/ProgressBar, GlobalVariables.curr_health, GlobalVariables.health)
	$AnimationPlayer.play("player_damage")
	await $AnimationPlayer.animation_finished
	dead()

func _on_run_pressed() -> void:
	$ActionPanel/HBoxContainer/Magic/MagicPanel.hide()
	$ActionPanel.hide()
	show_text("You ran away")
	_end_battle(false)


func _on_attack_pressed() -> void:
	show_text("You attack")
	await text_closed
	e_health = max(0, e_health - ((GlobalVariables.sword*GlobalVariables.attack_power)))
	set_health($EnemyContainer/ProgressBar, e_health, enemy.health)
	$AnimationPlayer.play("enemy_damage")
	await $AnimationPlayer.animation_finished
	show_text("You dealt %d damage." % (GlobalVariables.sword*GlobalVariables.attack_power))
	await text_closed
	if $EnemyContainer/ProgressBar.value == 0:
		dead()
	else :
		enemy_turn()


func _on_magic_pressed() -> void:
	$ActionPanel/HBoxContainer/Magic/MagicPanel.show()
	if GlobalVariables.fireball:
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button/MagicButton.text = GlobalVariables.f_name
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button/MagicButton/Label.text = ""
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button.show()

	if GlobalVariables.poison_sting && GameProgressSaver.is_completed("friends_with_anna"):
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button2/MagicButton.text = GlobalVariables.p_name
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button2/MagicButton/Label.text = ""
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button2.show()

	if GlobalVariables.sting_ray && GameProgressSaver.is_completed("friends_with_robert"):
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button3/MagicButton.text = GlobalVariables.b_name
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button3/MagicButton/Label.text = ""
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button3.show()

	

func fireball_pressed():
	$ActionPanel/HBoxContainer/Magic/MagicPanel.hide()
	show_text("You use fireball")
	await text_closed
	e_health = max(0, e_health - GlobalVariables.f_damage)
	set_health($EnemyContainer/ProgressBar, e_health, enemy.health)
	$AnimationPlayer.play("enemy_damage")
	await $AnimationPlayer.animation_finished
	show_text("You dealt %d damage." % GlobalVariables.f_damage)
	await text_closed
	if $EnemyContainer/ProgressBar.value == 0:
		dead()
	else :
		enemy_turn()

func poison_pressed():
	$ActionPanel/HBoxContainer/Magic/MagicPanel.hide()
	show_text("You use poison sting")
	await text_closed
	e_health = max(0, e_health - GlobalVariables.p_damage)
	set_health($EnemyContainer/ProgressBar, e_health, enemy.health)
	$AnimationPlayer.play("enemy_damage")
	await $AnimationPlayer.animation_finished
	show_text("You dealt %d damage." % GlobalVariables.p_damage)
	await text_closed
	_posion()
	if $EnemyContainer/ProgressBar.value == 0:
		dead()
	else :
		enemy_turn()

func bleed_pressed():
	$ActionPanel/HBoxContainer/Magic/MagicPanel.hide()
	show_text("You use sting ray")
	await text_closed
	e_health = max(0, e_health - GlobalVariables.b_damage)
	set_health($EnemyContainer/ProgressBar, e_health, enemy.health)
	$AnimationPlayer.play("enemy_damage")
	await $AnimationPlayer.animation_finished
	show_text("You dealt %d damage." % GlobalVariables.b_damage)
	await text_closed
	_bleed()
	if $EnemyContainer/ProgressBar.value == 0:
		dead()
	else :
		enemy_turn()

func _posion():
	if name == "Battle1":
		for i in range(15):
			await get_tree().create_timer(2.0).timeout
			e_health = max(0, e_health - GlobalVariables.p_effect)
			set_health($EnemyContainer/ProgressBar, e_health, enemy.health)
			if $EnemyContainer/ProgressBar.value == 0:
				dead()
				break

func _bleed():
	if name == "Battle1":
		for i in range(2):
			await get_tree().create_timer(30.0).timeout
			e_health = max(0, e_health - GlobalVariables.b_effect)
			set_health($EnemyContainer/ProgressBar, e_health, enemy.health)
			if $EnemyContainer/ProgressBar.value == 0:
				dead()
				break

func _on_item_pressed():
	var inv = PlayerInventory.inventory
	var y = 0
	if $ActionPanel/HBoxContainer/Item/ItemPanel/ItemContainer.get_child_count() == 0:
		for i in inv:
			y += 50
			var button_instance = button.instantiate()
			var button_name = button_instance.get_node("MagicButton")
			button_name.text = inv[i][0]
			var button_ammount = button_instance.get_node("MagicButton/Label")
			button_ammount.text = str(inv[i][1])
			#button_instance.position = Vector2(250, y)
			print("Hello1")
			$ActionPanel/HBoxContainer/Item/ItemPanel.size = Vector2(250, y)
			$ActionPanel/HBoxContainer/Item/ItemPanel/ItemContainer.add_child(button_instance)
			$ActionPanel/HBoxContainer/Item/ItemPanel/ItemContainer.add_spacer(false)
			print("Hello2")
	else :
		$ActionPanel/HBoxContainer/Item/ItemPanel.show()
		var items = $ActionPanel/HBoxContainer/Item/ItemPanel/ItemContainer.get_children()
		for i in range(0, items.size(), 2):
			if items[i] == button:
				var label_count = items[i].get_node("MagicButton/Label")
				if label_count.text == "0":
					items.remove_child(items[i])

func hide_item():
	$ActionPanel/HBoxContainer/Item/ItemPanel.hide()

func dead():
	if $EnemyContainer/ProgressBar.value == 0:
		$AnimationPlayer.play("enemy_dead")
		await $AnimationPlayer.animation_finished
		GlobalVariables.health = $PlayerPanel/HBoxContainer/ProgressBar.value
		show_text("The %s has been defeated." % enemy.name)
		await text_closed
		#PlayerLevel.exp_get(e_exp)
		#if PlayerLevel.current_exp >= PlayerLevel.level_2 and PlayerLevel.player_level == 1:
			#show_text("You are now level 2.")
			#await text_closed
			#show_text("You have learnt Poison Sting")
			#await text_closed
			#PlayerLevel.new_level.emit()
		#elif PlayerLevel.current_exp >= PlayerLevel.level_3 and PlayerLevel.player_level == 2:
			#show_text("You are now level 3.")
			#await text_closed
			#show_text("You have learnt Sting Ray")
			#await text_closed
			#PlayerLevel.new_level.emit()
		await get_tree().create_timer(0.25).timeout
		#get_tree().quit()
		_end_battle(true)
	elif $PlayerPanel/HBoxContainer/ProgressBar.value == 0:
		show_text("The Player has been defeated.")
		await text_closed
		await get_tree().create_timer(0.25).timeout
		#get_tree().quit()
		_end_battle(false)


#szymi 
##jest używane przy ucieczce, śmierci gracza lub przeciwnika
func _end_battle(enemy_died: bool):
	visible = false
	GlobalVariables.is_in_battle = false
	SignalBus.battle_ended.emit(enemy_died)
	if GlobalVariables.curr_health <= 0:
		GlobalVariables.curr_health = player_health 
		SceneManager.swap_scenes("res://scenes/UI/Main_Menu.tscn" ,get_tree().root , self.get_parent().get_parent() ,"no_to_transition")
	self.queue_free()
	#get_tree().quit()
	
func _player_joins_battle():
	###z ready
	death.connect(dead)
	SignalBus.hiding.connect(hide_item)
	SignalBus.health_up.connect(healing_item)
	item_press.connect(_on_item_pressed)
	
	var b = $ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button/MagicButton
	b.connect("pressed", fireball_pressed)
	
	var c = $ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button2/MagicButton
	c.connect("pressed", poison_pressed)
	
	var d =$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button3/MagicButton
	d.connect("pressed", bleed_pressed)
	#########
	#$ActionPanel/HBoxContainer/Item.emit(item_press)
	#print(GlobalVariables.cur_enemy)
	match GlobalVariables.cur_enemy:
		0:
			enemy = load("res://scripts/Enemies/StoreManager.tres")
		1:
			enemy = load("res://scripts/Enemies/Boss.tres")
		2:
			enemy = load("res://scripts/Enemies/LordOrigami.tres")
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/HBoxContainer/ProgressBar, GlobalVariables.curr_health, GlobalVariables.health)
	$EnemyContainer/Enemy.texture = enemy.texture
	e_health = enemy.health
	e_exp = enemy.enemy_exp
	$Textbox.hide()
	$ActionPanel.hide()
	$ActionPanel/HBoxContainer/Magic/MagicPanel.hide()
	$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button.hide()
	$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button2.hide()
	$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button3.hide()
	for i in PlayerInventory.equips:
		if PlayerInventory.equips[i][3] == "Shirt":
			GlobalVariables.player_shirt = PlayerInventory.equips[i][4]
		if PlayerInventory.equips[i][3] == "Pants":
			GlobalVariables.player_pants = PlayerInventory.equips[i][4]
		if PlayerInventory.equips[i][3] == "Shoes":
			GlobalVariables.player_boots = PlayerInventory.equips[i][4]
		if PlayerInventory.equips[i][3] == "Sword":
			GlobalVariables.sword = PlayerInventory.equips[i][4]
	visible = true
	$AnimationPlayer.play("RESET")
	show_text("A wild %s appears" % enemy.name)
	await text_closed
	show_text("Stop right there")
	await text_closed
	$ActionPanel.show()
	###z item_pressedA
	#$ActionPanel/HBoxContainer/Item/ItemPanel.show()
	var items = $ActionPanel/HBoxContainer/Item/ItemPanel/ItemContainer.get_children()
	for i in range(0, items.size(), 2):
		if items[i] == button:
			var label_count = items[i].get_node("MagicButton/Label")
			if label_count.text == "0":
				items.remove_child(items[i])
