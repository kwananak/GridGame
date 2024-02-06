extends Control

signal exit_options_menu
@onready var exit = $MarginContainer/VBoxContainer/Exit

func _ready():
	set_process(false)

func _on_exit_button_down():
	exit_options_menu.emit()
	set_process(false)

func _on_visibility_changed():
	if visible:
		exit.grab_focus()
