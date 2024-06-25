extends Control

@onready var options_menu = $OptionsMenu
@onready var margin_container = $TitleMenu/MarginContainer
@onready var new_game = $TitleMenu/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/NewGame
@onready var continue_game = $TitleMenu/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ContinueGame
@onready var main = $/root/Main
@onready var fader = $Fader/AnimationPlayer
@onready var fader_2 = $Fader2/AnimationPlayer
@onready var debug_menu = $/root/Main/DebugMenu

func _ready():
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	new_game.grab_focus()

func _on_new_game_button_down():
	if !continue_game.disabled:
		$ConfirmBox.show()
		$ConfirmBox/NoButton.grab_focus()
	else:
		confirm_new_game()

func _continue_game_button_down():
	$ConfirmBox.hide()
	main.continue_game()

func _on_options_button_down():
	$ConfirmBox.hide()
	margin_container.set_process(false)
	margin_container.hide()
	options_menu.set_process(true)
	options_menu.show()

func _on_quit_button_down():
	get_tree().quit()

func on_exit_options_menu():
	options_menu.set_process(false)
	options_menu.hide()
	if debug_menu.visible:
		hide()
		debug_menu.get_node("ContinueGame").grab_focus()
	else:
		margin_container.set_process(true)
		margin_container.show()
		new_game.grab_focus()

func confirm_new_game():
	var buttons = $TitleMenu/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer.get_children()
	for n in buttons:
		n.disabled = true
	$ConfirmBox.hide()
	await main.new_game()
	for n in buttons:
		n.disabled = false

func remove_confirm_box():
	$ConfirmBox.hide()
	continue_game.grab_focus()

func menu_fade():
	fader.play("fade_out")
	create_tween().tween_property($MenuAudio, "volume_db", -80.0, 3.0).set_trans(Tween.TRANS_SINE)
	await fader.animation_finished
	await get_tree().create_timer(1.0).timeout
	fader_2.play("fade_out")
	await fader_2.animation_finished
	$Fader.color.a = 0
	$Fader2.color.a = 0
	$MenuAudio.stop()
	$MenuAudio.volume_db = 0
