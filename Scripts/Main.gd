extends Node2D

var menu

func _ready():
	menu = get_node("Menu")

# instantiates chosen level from main menu
func call_level(level_number):
	menu.visible = false
	add_child(load("res://Scenes/Level" + str(level_number) + ".tscn").instantiate())

# destroy level scene and calls menu after level ends
func call_menu(level_number):
	remove_child(get_node("Level" + str(level_number)))
	menu.visible = true

# quits game when quit button is pressed
func call_quit():
	get_tree().quit()
