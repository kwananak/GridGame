extends Node2D

@onready var menu = $"Menu"

# instantiates chosen level from main menu
func call_level(level_number):
	menu.visible = false
	add_child(load("res://Scenes/Level" + str(level_number) + ".tscn").instantiate())

# destroys level scene and calls menu after level ends
func call_menu(level_number):
	if level_number == 0:
		remove_child(get_node("TestLevel"))
	else:
		remove_child(get_node("Level" + str(level_number)))
	get_node("Camera2D").position = Vector2(288, 160)
	menu.visible = true

# quits game when quit button is pressed
func call_quit():
	get_tree().quit()

# instantiates test level from main menu
func _on_test_level_button_pressed():
	menu.visible = false
	add_child(load("res://Scenes/test_level.tscn").instantiate())
