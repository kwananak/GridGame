extends Control

var toggled = false

var key_config
var joypad_config

@onready var label = $HBoxContainer/Label
@onready var button = $HBoxContainer/Button

@export var action_name : String

func _ready():
	set_action_name()
	set_text_for_key()

func set_action_name():
	label.text = action_name

func set_text_for_key():
	button.text = OS.get_keycode_string(InputMap.action_get_events(name)[0].physical_keycode)

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
		if event is InputEventKey:
			if event.is_pressed():
				rebind_action_key(false, event)
				toggled = false
				button.focus_mode = FOCUS_ALL
				button.grab_focus()

func rebind_action_key(joypad, event):
	if !joypad:
		InputMap.action_erase_events(name)
		InputMap.action_add_event(name, event)
		set_text_for_key()
