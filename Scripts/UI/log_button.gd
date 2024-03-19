extends Control

var moused = false
var loadout
var logs
var prog_load

func _ready():
	loadout = get_tree().get_first_node_in_group("Loadout")
	logs = get_tree().get_first_node_in_group("Log")
	prog_load = get_tree().get_first_node_in_group("ProgressManager").get_node("Loadout")

func _input(event):
	if has_focus():
		if event.is_action_pressed("ui_accept"):
			toggle_log()
		if event is InputEventMouseButton:
			if event.is_pressed() && event.button_index == 1 && moused:
				toggle_log()

func toggle_log():
	if logs.visible:
		logs.hide()
		loadout.show()
		prog_load.show()
	else:
		logs.show()
		loadout.hide()
		prog_load.hide()

func _on_focus_entered():
	$Focus.visible = true

func _on_focus_exited():
	$Focus.visible = false

func _on_mouse_entered():
	if loadout.selection_opened:
		return
	grab_focus()
	moused = true

func _on_mouse_exited():
	moused = false
