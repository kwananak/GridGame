extends Node2D

@onready var main = $/root/Main

func _ready():
	$Control/ReturnButton.grab_focus()

func _input(event):
	if visible == false:
		return
	if event.is_action_pressed("pause"):
		_on_return_button_pressed()

# called by return button to send the player back to the real world
func _on_return_button_pressed():
	main.return_to_real_scene()
	queue_free()

# called by map button to send the player to the virtual world
func _on_virtual_test_level_button_pressed():
	main.call_test_level("virtual")
	visible = false

func _on_level_pressed(level_number):
	$/root/Main.call_level(level_number)
	visible = false
