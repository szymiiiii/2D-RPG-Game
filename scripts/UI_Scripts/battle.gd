extends Control


signal text_closed
@export var enemy: Resource = null
var player_health = GlobalVariables.curr_health
var e_health: int


func _ready() -> void:
	SignalBus.is_in_battle.connect(_player_joins_battle)
	SignalBus.fireball.connect(fireball_pressed)
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/HBoxContainer/ProgressBar, GlobalVariables.curr_health, GlobalVariables.health)
	$EnemyContainer/Enemy.texture = enemy.texture
	e_health = enemy.health
	$Textbox.hide()
	$ActionPanel.hide()
	$MagicPanel.hide()
	$MagicPanel/MagicContainer/Button.hide()
	$MagicPanel/MagicContainer/Button2.hide()
	$MagicPanel/MagicContainer/Button3.hide()
	print("visible")
	visible = false
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
	if $EnemyContainer/ProgressBar.value == 0:
		$AnimationPlayer.play("enemy_dead")
		await $AnimationPlayer.animation_finished
		GlobalVariables.health = $PlayerPanel/HBoxContainer/ProgressBar.value
		show_text("The %s has been defeated." % enemy.name)
		_end_battle()
	enemy_turn()


func _on_magic_pressed() -> void:
	$MagicPanel.show()
	if GlobalVariables.fireball:
		$MagicPanel/MagicContainer/Button/MagicButton.text = GlobalVariables.f_name
		$MagicPanel/MagicContainer/Button.show()
		var b = $MagicPanel/MagicContainer/Button/MagicButton
		b.connect("pressed", fireball_pressed)
	if GlobalVariables.poison_sting:
		$MagicPanel/MagicContainer/Button2/MagicButton.text = GlobalVariables.p_name
		$MagicPanel/MagicContainer/Button2/MagicButton/Label.text = "%dmp" % GlobalVariables.p_cost
		$MagicPanel/MagicContainer/Button2.show()
		var c = $MagicPanel/MagicContainer/Button2/MagicButton
		c.connect("pressed", poison_pressed)
	if GlobalVariables.sting_ray:
		$MagicPanel/MagicContainer/Button3/MagicButton.text = GlobalVariables.b_name
		$MagicPanel/MagicContainer/Button3/MagicButton/Label.text = "%dmp" % GlobalVariables.b_cost
		$MagicPanel/MagicContainer/Button3.show()
	

func fireball_pressed():
	show_text("You use fireball")
	await text_closed
	e_health = max(0, e_health - GlobalVariables.f_damage)
	set_health($EnemyContainer/ProgressBar, e_health, enemy.health)
	$AnimationPlayer.play("enemy_damage")
	await $AnimationPlayer.animation_finished
	show_text("You dealt %d damage." % GlobalVariables.f_damage)
	await text_closed
	if $EnemyContainer/ProgressBar.value == 0:
		$AnimationPlayer.play("enemy_dead")
		await $AnimationPlayer.animation_finished
		GlobalVariables.health = $PlayerPanel/HBoxContainer/ProgressBar.value
		show_text("The %s has been defeated." % enemy.name)
		_end_battle()
	enemy_turn()

func poison_pressed():
	show_text("You use poison sting")
	await text_closed
	e_health = max(0, e_health - GlobalVariables.p_damage)
	set_health($EnemyContainer/ProgressBar, e_health, enemy.health)
	$AnimationPlayer.play("enemy_damage")
	await $AnimationPlayer.animation_finished
	show_text("You dealt %d damage." % GlobalVariables.p_damage)
	await text_closed
	if $EnemyContainer/ProgressBar.value == 0:
		$AnimationPlayer.play("enemy_dead")
		await $AnimationPlayer.animation_finished
		GlobalVariables.health = $PlayerPanel/HBoxContainer/ProgressBar.value
		show_text("The %s has been defeated." % enemy.name)
		_end_battle()
	enemy_turn()
	
func _end_battle():
	await text_closed
	await get_tree().create_timer(0.25).timeout
	visible = false
	#get_tree().quit()
	
func _player_joins_battle():
	
	visible = true
