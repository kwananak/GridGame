extends Node2D

var real_scene
var terminal_scene
var virtual_scene

@onready var menu = $Menu
@onready var camera_2d = $Camera2D
@onready var progress_manager = $ProgressManager

func _ready():
	$Menu/QuitButton.grab_focus()

# instantiates chosen level
func call_level(level_number):
	$AudioStreamPlayer.stop()
	menu.visible = false
	var level
	if level_number == 100:
		level = load("res://Scenes/virtual_test_level.tscn").instantiate()
	elif level_number == 0:
		level = load("res://Scenes/real_test_level.tscn").instantiate()
	else:
		level = load("res://Scenes/Levels/Level" + str(level_number) + ".tscn").instantiate()
	if level_number < 100:
		real_scene = level
	else:
		virtual_scene = level
	add_child(level)

### needs cleanup ###
# handles various level quitting scenario, needs cleanup
func call_menu(level_number):
	$AudioStreamPlayer.play()
	if level_number == 100:
		get_node("VirtualTestLevel").queue_free()
	elif level_number == 0:
		get_node("RealTestLevel").queue_free()
	else:
		get_node("Level" + str(level_number)).queue_free()
	if real_scene and terminal_scene != null:
		camera_2d.position = $TerminalScene.position + get_viewport_rect().size / 4
		$TerminalScene/Control/Loadout.set_slots()
		$TerminalScene.visible = true
		$TerminalScene._ready()
	else:
		camera_2d.position = get_viewport_rect().size / 4
		menu.visible = true
		$Menu/QuitButton.grab_focus()

# quits game when quit button is pressed
func call_quit():
	get_tree().quit()

# instantiates terminal scene and hides + pauses real scene when called
func call_terminal_scene():
	remove_child(real_scene)
	terminal_scene = load("res://Scenes/terminal_scene.tscn").instantiate()
	add_child(terminal_scene)
	$TerminalScene.position = camera_2d.position - get_viewport_rect().size / 4

# returns to real scene when closing terminal
func return_to_real_scene():
	add_child(real_scene)
	for n in get_tree().get_nodes_in_group("TerminalDoors"):
		n.update_door()

# resets game status and starts Level 1
func new_game_button():
	await progress_manager.reset_programs()
	call_level(1)
