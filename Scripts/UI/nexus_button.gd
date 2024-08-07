extends Control

var available = false : set = set_available
var moused = false
var terminal_scene
var loadout

func _ready():
	terminal_scene = get_tree().get_first_node_in_group("TerminalScene")
	loadout = get_tree().get_first_node_in_group("Loadout")

func _input(event):
	if !available:
		return
	if has_focus():
		if event.is_action_pressed("ui_accept"):
			terminal_scene._on_go_button_pressed()
		if event is InputEventMouseButton:
			if event.is_pressed() && event.button_index == 1 && moused:
				terminal_scene._on_go_button_pressed()

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
	terminal_scene.get_node("Map/Level" + str(terminal_scene.loaded_level)).set_labels()

func _on_focus_exited():
	$Selected.visible = false
	terminal_scene.get_node("Map/Level" + str(terminal_scene.loaded_level)).clear_labels()

func _on_mouse_entered():
	if focus_mode == FOCUS_NONE || loadout.selection_opened:
		return
	grab_focus()
	moused = true

func _on_mouse_exited():
	moused = false
