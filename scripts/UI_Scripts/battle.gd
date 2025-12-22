extends Control

signal item_press
signal text_closed
@export var enemy: Resource = null
var player_health = GlobalVariables.curr_health
@export var e_health: int
const InventoryClass = preload("res://scripts/Inventory/PlayerInventory.gd")
const ItemClass = preload("res://scripts/Inventory/Item_script.tres.gd")
@onready var button = preload("res://scenes/Battle/Button1.tscn")

func _ready() -> void:
	SignalBus.poisoned.connect(_posion)
	SignalBus.fireball.connect(fireball_pressed)
	item_press.connect(_on_item_pressed)
	#$ActionPanel/HBoxContainer/Item.emit(item_press)
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/HBoxContainer/ProgressBar, GlobalVariables.curr_health, GlobalVariables.health)
	$EnemyContainer/Enemy.texture = enemy.texture
	e_health = enemy.health
	$Textbox.hide()
	$ActionPanel.hide()
	$ActionPanel/HBoxContainer/Magic/MagicPanel.hide()
	$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button.hide()
	$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button2.hide()
	$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button3.hide()
	show_text("A wild %s appears" % enemy.name)
	await text_closed
	show_text("Stop right there")
	await text_closed
	$ActionPanel.show()
	
func _input(event) -> void:
	if (Input.is_action_just_pressed("Interact") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("text_closed")

func set_health(progress_bar, health, max_health) -> void:
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]


func show_text(text):
	$Textbox.show()
	$Textbox/Label.text = text

func enemy_turn() -> void:
	show_text("%s charges at you" % enemy.name)
	await text_closed
	GlobalVariables.curr_health = max(0, GlobalVariables.curr_health - enemy.damage)
	set_health($PlayerPanel/HBoxContainer/ProgressBar, GlobalVariables.curr_health, GlobalVariables.health)
	$AnimationPlayer.play("player_damage")
	await $AnimationPlayer.animation_finished

func _on_run_pressed() -> void:
	$MagicPanel.hide()
	$ActionPanel.hide()
	show_text("You ran away")
	await text_closed
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()


func _on_attack_pressed() -> void:
	show_text("You attack")
	await text_closed
	e_health = max(0, e_health - (GlobalVariables.sword*GlobalVariables.attack_power))
	set_health($EnemyContainer/ProgressBar, e_health, enemy.health)
	$AnimationPlayer.play("enemy_damage")
	await $AnimationPlayer.animation_finished
	show_text("You dealt %d damage." % (GlobalVariables.sword*GlobalVariables.attack_power))
	await text_closed
	dead()
	enemy_turn()


func _on_magic_pressed() -> void:
	$ActionPanel/HBoxContainer/Magic/MagicPanel.show()
	if GlobalVariables.fireball:
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button/MagicButton.text = GlobalVariables.f_name
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button.show()
		var b = $ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button/MagicButton
		b.connect("pressed", fireball_pressed)
	if GlobalVariables.poison_sting:
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button2/MagicButton.text = GlobalVariables.p_name
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button2/MagicButton/Label.text = "%dmp" % GlobalVariables.p_cost
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button2.show()
		var c = $ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button2/MagicButton
		c.connect("pressed", poison_pressed)
	if GlobalVariables.sting_ray:
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button3/MagicButton.text = GlobalVariables.b_name
		$ActionPanel/HBoxContainer/Magic/MagicPanel/MagicContainer/Button3/MagicButton/Label.text = "%dmp" % GlobalVariables.b_cost
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
	dead()
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
	SignalBus.poisoned.emit()
	dead()
	enemy_turn()

func _posion():
	if get_tree().current_scene.name == "Battle1":
		for i in range(15):
			await get_tree().create_timer(2.0).timeout
			e_health = max(0, e_health - GlobalVariables.p_effect)
			set_health($EnemyContainer/ProgressBar, e_health, enemy.health)
			if $EnemyContainer/ProgressBar.value == 0:
				dead()
				break

func _on_item_pressed():
	var inv = PlayerInventory.inventory
	var y = 0
	for i in inv:
		y += 50
		var button_instance = button.instantiate()
		var button_name = button_instance.get_node("MagicButton")
		button_name.text = inv[i][0]
		var button_ammount = button_instance.get_node("MagicButton/Label")
		button_ammount.text = str(inv[i][1])
		print("Hello1")
		$ActionPanel/HBoxContainer/Item/ItemPanel.size = Vector2(250, y)
		$ActionPanel/HBoxContainer/Item/ItemPanel/ItemContainer.add_child(button_instance)
		print("Hello2")

func dead():
	if $EnemyContainer/ProgressBar.value == 0:
		$AnimationPlayer.play("enemy_dead")
		await $AnimationPlayer.animation_finished
		GlobalVariables.health = $PlayerPanel/HBoxContainer/ProgressBar.value
		show_text("The %s has been defeated." % enemy.name)
		await text_closed
		if PlayerLevel.current_exp >= PlayerLevel.level_2 and PlayerLevel.player_level == 1:
			PlayerLevel.new_level.emit()
		elif PlayerLevel.current_exp >= PlayerLevel.level_3 and PlayerLevel.player_level == 2:
			PlayerLevel.new_level.emit()
		await get_tree().create_timer(0.25).timeout
		get_tree().quit()
