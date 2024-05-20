extends Control

@onready var tab_container = $TabContainer
var exit_button
var config_path = "user://config.save"
var config = {}

func _ready():
	exit_button = get_tree().get_first_node_in_group("OptionExitButton")
	await get_tree().create_timer(1.3).timeout
	load_config()

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

func save_config():
	for n in $TabContainer/Audio/MarginContainer/VBoxContainer.get_children():
		config[n.name] = n.h_slider.value
	for n in $TabContainer/Video/MarginContainer/VBoxContainer.get_children():
		config[n.name] = n.get_node("HBoxContainer/OptionButton").selected
	var config_file = FileAccess.open(config_path, FileAccess.WRITE)
	config_file.store_line(JSON.stringify(config))
	config_file.close()

func load_config():
	if not FileAccess.file_exists(config_path):
		return
	var config_file = FileAccess.open(config_path, FileAccess.READ)
	var json_string = config_file.get_line()
	config_file.close()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var data = json.get_data()
	for n in data:
		if $TabContainer/Audio/MarginContainer/VBoxContainer.has_node(n):
			$TabContainer/Audio/MarginContainer/VBoxContainer.get_node(n).h_slider.value = data[n]
		else:
			$TabContainer/Video/MarginContainer/VBoxContainer.get_node(n + "/HBoxContainer/OptionButton").selected = data[n]
	var win_mode = get_tree().get_first_node_in_group("WindowModeButton").get_node("HBoxContainer/OptionButton")
	win_mode.item_selected.emit(win_mode.selected)
	win_mode.item_selected.emit(win_mode.selected)
