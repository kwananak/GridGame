extends Control

var moused = false

func _input(event):
	if has_focus():
		if event.is_action_pressed("ui_accept"):
			get_tree().get_first_node_in_group("TerminalScene")._on_return_button_pressed()
		if event is InputEventMouseButton:
			if event.is_pressed() && event.button_index == 1 && moused:
				get_tree().get_first_node_in_group("TerminalScene")._on_return_button_pressed()

func _on_focus_entered():
	$Focus.visible = true

func _on_focus_exited():
	$Focus.visible = false

func _on_mouse_entered():
	grab_focus()
	moused = true

func _on_mouse_exited():
	moused = false
