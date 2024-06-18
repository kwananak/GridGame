extends Control

var exit_button
var config_path = "user://config.save"
var config = {}
var joypad_config = false : set = set_joypad_config

signal joypad_config_signal

@onready var tab_container = $TabContainer
func _ready():
	exit_button = get_tree().get_first_node_in_group("OptionExitButton")
	await get_tree().create_timer(1.3).timeout
	load_config()

func _input(event):
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		joypad_config = true
	else:
		joypad_config = false

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q:
			if tab_container.current_tab > 0:
				tab_container.current_tab -= 1
				exit_button.grab_focus()
		if event.keycode == KEY_E:
			if tab_container.current_tab < 2:
				tab_container.current_tab += 1
				exit_button.grab_focus()
	if event is InputEventJoypadButton and event.pressed:
		if event.button_index == 9:
			if tab_container.current_tab > 0:
				tab_container.current_tab -= 1
				exit_button.grab_focus()
		if event.button_index == 10:
			if tab_container.current_tab < 2:
				tab_container.current_tab += 1
				exit_button.grab_focus()

func set_joypad_config(value):
	if value == joypad_config:
		return
	joypad_config = value
	joypad_config_signal.emit(value)
	if value:
		$Label.text = "LT"
		$Label2.text = "RT"
	else:
		$Label.text = "Q"
		$Label2.text = "E"
		

func save_config():
	for n in $TabContainer/Audio/MarginContainer/VBoxContainer.get_children():
		config[n.name] = n.h_slider.value
	for n in $TabContainer/Video/MarginContainer/VBoxContainer.get_children():
		config[n.name] = n.get_node("HBoxContainer/OptionButton").selected
	for m in get_tree().get_nodes_in_group("ControlsContainer"):
		for n in m.get_children():
			config[n.name] = {"keyboard":null,"joypad":null}
			for o in InputMap.action_get_events(n.name):
				if o is InputEventKey:
					config[n.name]["keyboard"] = o.physical_keycode
				if o is InputEventJoypadButton:
					config[n.name]["joypad"] = "B" + str(o.button_index)
				if o is InputEventJoypadMotion:
					var v = "M"
					v += str(o.axis)
					if o.axis_value < 0:
						v += "-"
					config[n.name]["joypad"] = v
	var config_file = FileAccess.open(config_path, FileAccess.WRITE)
	config_file.store_line(JSON.stringify(config))
	config_file.close()

func load_config():
	var win_mode = get_tree().get_first_node_in_group("WindowModeButton").get_node("HBoxContainer/OptionButton")
	if not FileAccess.file_exists(config_path):
		win_mode.selected = 2
		get_tree().get_first_node_in_group("ResolutionButton").get_node("HBoxContainer/OptionButton").selected = 3
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
		elif $TabContainer/Video/MarginContainer/VBoxContainer.has_node(n):
			$TabContainer/Video/MarginContainer/VBoxContainer.get_node(n + "/HBoxContainer/OptionButton").selected = data[n]
		else:
			var setting
			for o in get_tree().get_nodes_in_group("ControlsContainer"):
				if o.has_node(n):
					setting = o.get_node(n)
			var key = InputEventKey.new()
			key.physical_keycode = data[n]["keyboard"]
			setting.rebind_action_key(key)
			var joy = data[n]["joypad"]
			if joy.begins_with("M"):
				var move = InputEventJoypadMotion.new()
				move.axis = int(joy.substr(1, 1))
				if joy.length() == 3:
					move.axis_value = -1.00
				setting.rebind_action_key(move)
			else:
				var button = InputEventJoypadButton.new()
				button.button_index = int(joy)
				setting.rebind_action_key(button)
	win_mode.item_selected.emit(win_mode.selected)
	win_mode.item_selected.emit(win_mode.selected)
