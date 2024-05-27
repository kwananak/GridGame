extends Control

@onready var options_menu = $OptionsMenu
@onready var margin_container = $TitleMenu/MarginContainer
@onready var new_game = $TitleMenu/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/NewGame
@onready var continue_game = $TitleMenu/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ContinueGame
@onready var main = $/root/Main

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
	margin_container.set_process(true)
	margin_container.show()
	new_game.grab_focus()

func confirm_new_game():
	$ConfirmBox.hide()
	main.new_game()

func remove_confirm_box():
	$ConfirmBox.hide()
	continue_game.grab_focus()
