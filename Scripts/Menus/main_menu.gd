extends Control

@onready var options_menu = $OptionsMenu
@onready var margin_container = $MarginContainer
@onready var new_game = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/NewGame
@onready var continue_game = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/ContinueGame

func _ready():
	options_menu.exit_options_menu.connect(on_exit_options_menu)
	new_game.grab_focus()

func _on_new_game_button_down():
	$/root/Main.new_game()

func _continue_game_button_down():
	$/root/Main.continue_game()

func _on_options_button_down():
	margin_container.set_process(false)
	margin_container.hide()
	options_menu.set_process(true)
	options_menu.show()

func _on_quit_button_down():
	get_tree().quit()

func on_exit_options_menu():
	options_menu.hide()
	margin_container.show()
	margin_container.set_process(true)
