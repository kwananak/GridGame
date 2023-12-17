extends Node2D

var real_scene

@onready var menu = $Menu
@onready var camera_2d = $Camera2D
@onready var progress_manager = $ProgressManager

func _ready():
	$Menu/QuitButton.grab_focus()

# instantiates chosen level from main menu
func call_level(level_number):
	menu.visible = false
	if level_number == 0:
		add_child(load("res://Scenes/virtual_test_level.tscn").instantiate())
	elif level_number < 0:
		add_child(load("res://Scenes/real_test_level.tscn").instantiate())
	else:
		add_child(load("res://Scenes/Levels/Level" + str(level_number) + ".tscn").instantiate())

# instantiates test level from main menu
func call_test_level(test_name):
	menu.visible = false
	add_child(load("res://Scenes/" + test_name + "_test_level.tscn").instantiate())

### needs cleanup ###
# handles various level quitting scenario, needs cleanup
func call_menu(level_number):
	if level_number == 0:
		get_node("VirtualTestLevel").queue_free()
	elif level_number < 0:
		get_node("RealTestLevel").queue_free()
	else:
		get_node("Level" + str(level_number)).queue_free()
	if real_scene != null and $TerminalScene != null:
		camera_2d.position = $TerminalScene.position + Vector2(288, 160)
		$TerminalScene/Control/Loadout.set_slots()
		$TerminalScene.visible = true
		$TerminalScene._ready()
	else:
		camera_2d.position = Vector2(288, 160)
		menu.visible = true

# quits game when quit button is pressed
func call_quit():
	get_tree().quit()

# instantiates terminal scene and hides + pauses real scene when called
func call_terminal_scene(from_scene):
	real_scene = from_scene
	remove_child(real_scene)
	add_child(load("res://Scenes/terminal_scene.tscn").instantiate())
	$TerminalScene.position = camera_2d.position - Vector2(288, 160)

# returns to real scene when closing terminal
func return_to_real_scene():
	add_child(real_scene)
