extends Control

var toggled = false

@onready var label = $HBoxContainer/Label
@onready var button = $HBoxContainer/Button

@export var action_name : String

func _ready():
	set_action_name()
	set_text_for_key()

func set_action_name():
	label.text = action_name

func set_text_for_key():
	var action_event = InputMap.action_get_events(name)[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	button.text = action_keycode


func _on_button_down():
	if !toggled:
		button.text = "Press key"
		toggled = true
		for n in get_tree().get_nodes_in_group("HotkeyButton"):
			if n.name != name:
				n.toggled = false
				n.set_text_for_key()
	else:
		button.release_focus()
		for n in get_tree().get_nodes_in_group("HotkeyButton"):
			n.toggled = false
			n.set_text_for_key()

func _unhandled_key_input(event):
	if toggled:
		rebind_action_key(event)
		toggled = false
		button.release_focus()

func rebind_action_key(event):
	InputMap.action_erase_events(name)
	InputMap.action_add_event(name, event)
	set_text_for_key()
