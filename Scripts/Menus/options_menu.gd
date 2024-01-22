extends Control

signal exit_options_menu

func _ready():
	set_process(false)

func _on_exit_button_down():
	exit_options_menu.emit()
	set_process(false)
