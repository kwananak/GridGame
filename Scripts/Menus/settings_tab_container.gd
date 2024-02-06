extends Control

@onready var tab_container = $TabContainer
var exit_button

func _ready():
	exit_button = get_tree().get_first_node_in_group("OptionExitButton")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q:
			if tab_container.current_tab > 0:
				tab_container.current_tab -= 1
				exit_button.grab_focus()
		if event.keycode == KEY_E:
			if tab_container.current_tab < 2:
				tab_container.current_tab += 1
				exit_button.grab_focus()
