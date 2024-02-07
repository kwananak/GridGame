extends Control

var available = false : set = set_available
var moused = false

func _input(event):
	if !available:
		return
	if has_focus():
		if event.is_action_pressed("ui_accept"):
			get_tree().get_first_node_in_group("TerminalScene")._on_go_button_pressed()
		if event is InputEventMouseButton:
			if event.is_pressed() && event.button_index == 1 && moused:
				get_tree().get_first_node_in_group("TerminalScene")._on_go_button_pressed()

func set_available(value):
	available = value
	if value:
		focus_mode = Control.FOCUS_ALL
		$Available.frame = 1
	else:
		focus_mode = Control.FOCUS_NONE
		$Available.frame = 0

func _on_focus_entered():
	$Selected.visible = true
	get_tree().get_first_node_in_group("LevelNameLabel").text = $/root/Main.get_level_name((get_tree().get_first_node_in_group("TerminalScene").loaded_level))

func _on_focus_exited():
	$Selected.visible = false
	get_tree().get_first_node_in_group("LevelNameLabel").text = ""

func _on_mouse_entered():
	if focus_mode == FOCUS_NONE:
		return
	grab_focus()
	moused = true

func _on_mouse_exited():
	moused = false
