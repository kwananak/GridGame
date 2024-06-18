extends Control

var toggled = false

var settings

@onready var label = $HBoxContainer/Label
@onready var button = $HBoxContainer/Button

@export var action_name : String

func _ready():
	settings = get_tree().get_first_node_in_group("Settings")
	settings.joypad_config_signal.connect(config_changed)
	set_action_name()
	set_text_for_key()

func config_changed(_joypad):
	set_text_for_key()

func set_action_name():
	label.text = action_name

func set_text_for_key():
	for n in InputMap.action_get_events(name):
		if n is InputEventKey && !settings.joypad_config:
			button.text = OS.get_keycode_string(n.physical_keycode)
		if n is InputEventJoypadButton && settings.joypad_config:
			button.text = "Button " + str(n.button_index)
		if n is InputEventJoypadMotion && settings.joypad_config:
			if n.axis_value < 0:
				button.text = "Axis -" + str(n.axis)
			else:
				button.text = "Axis " + str(n.axis)

func _on_button_down():
	if !toggled:
		button.text = "Press key"
		for n in get_tree().get_nodes_in_group("HotkeyButton"):
			n.button.release_focus()
			if n != self:
				n.toggled = false
				n.set_text_for_key()
		await get_tree().create_timer(0.1).timeout
		toggled = true
	else:
		for n in get_tree().get_nodes_in_group("HotkeyButton"):
			n.button.focus_mode = FOCUS_ALL
			n.toggled = false
			n.set_text_for_key()

func _input(event):
	if toggled:
		get_viewport().set_input_as_handled()
		if event is InputEventKey && !settings.joypad_config:
			if event.is_pressed():
				rebind_action_key(event)
				toggled = false
				button.focus_mode = FOCUS_ALL
				button.grab_focus()
		if event is InputEventJoypadButton && settings.joypad_config:
			if event.is_pressed():
				rebind_action_key(event)
				toggled = false
				button.focus_mode = FOCUS_ALL
				button.grab_focus()
		if event is InputEventJoypadMotion && settings.joypad_config:
			if event.axis_value > 0.5 || event.axis_value < -0.5:
				rebind_action_key(event)
				toggled = false
				await get_tree().create_timer(0.1).timeout
				button.focus_mode = FOCUS_ALL
				button.grab_focus()

func rebind_action_key(event):
	for n in InputMap.action_get_events(name):
		if (n is InputEventKey && event is InputEventKey) || (!(n is InputEventKey) && !(event is InputEventKey)):
			InputMap.action_erase_event(name, n)
			InputMap.action_add_event(name, event)
			set_text_for_key()
