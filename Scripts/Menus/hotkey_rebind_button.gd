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
			match n.button_index:
				0:
					button.text = "A"
				1:
					button.text = "B"
				2:
					button.text = "X"
				3:
					button.text = "Y"
				4:
					button.text = "SELECT"
				5:
					button.text = "HOME"
				6:
					button.text = "START"
				7:
					button.text = "L3"
				8:
					button.text = "R3"
				9:
					button.text = "L1"
				10:
					button.text = "R1"
				11:
					button.text = "DPAD UP"
				12:
					button.text = "DPAD DOWN"
				13:
					button.text = "DPAD LEFT"
				14:
					button.text = "DPAD RIGHT"
				15:
					button.text = "SHARE"
				16:
					button.text = "PADDLE 1"
				17:
					button.text = "PADDLE 2"
				18:
					button.text = "PADDLE 3"
				19:
					button.text = "PADDLE 4"
				20:
					button.text = "TOUCHPAD"
				_:
					button.text = "Button " + str(n.button_index)
		if n is InputEventJoypadMotion && settings.joypad_config:
			match n.axis:
				0:
					if n.axis_value < 0:
						button.text = "LEFT STICK LEFT"
					else:
						button.text = "LEFT STICK RIGHT"
				1:
					if n.axis_value < 0:
						button.text = "LEFT STICK UP"
					else:
						button.text = "LEFT STICK DOWN"
				2:
					if n.axis_value < 0:
						button.text = "RIGHT STICK LEFT"
					else:
						button.text = "RIGHT STICK RIGHT"
				3:
					if n.axis_value < 0:
						button.text = "RIGHT STICK UP"
					else:
						button.text = "RIGHT STICK DOWN"
				4:
					if n.axis_value < 0:
						button.text = "STICK 2 LEFT"
					else:
						button.text = "L2"
				5:
					if n.axis_value < 0:
						button.text = "STICK 2 UP"
					else:
						button.text = "R2"

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
