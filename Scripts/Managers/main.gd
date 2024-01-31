extends Node2D

var real_scene
var terminal_scene
var virtual_scene
var menu
var menu_audio
var continue_button
var new_game_button

@onready var camera = $Camera2D
@onready var progress_manager = $ProgressManager

func _ready():
	set_menu()

# looks for visible menu (main or debug) and adds needed references
func set_menu():
	if $DebugMenu.visible:
		$MainMenu.visible = false
		menu = $DebugMenu
		continue_button = $DebugMenu/ContinueGame
		new_game_button = $DebugMenu/NewGame
		new_game_button.grab_focus()
	else:
		menu = $MainMenu
		continue_button = menu.continue_game
		new_game_button = menu.new_game
		await progress_manager.load_game()
		if progress_manager.save_point:
			continue_button.grab_focus()
		else:
			continue_button.disabled = true
			new_game_button.grab_focus()
	menu_audio = menu.get_node("MenuAudio")
	menu_audio.play()

# instantiates chosen level
func call_level(level_number):
	menu_audio.stop()
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
		if has_node("RealAudio"):
			$RealAudio.stop()
		virtual_scene = level
	add_child(level)

### needs cleanup ###
# handles various level quitting scenario, needs cleanup
func call_menu(level_number):
	if level_number == 100:
		get_node("VirtualTestLevel").queue_free()
	elif level_number == 0:
		$RealAudio.stop()
		get_node("RealTestLevel").queue_free()
	elif level_number < 100:
		remove_child(real_scene)
		$RealAudio.stop()
	else:
		get_node("Level" + str(level_number)).queue_free()
	if real_scene and terminal_scene != null:
		$RealAudio.play()
		camera.position = terminal_scene.position + get_viewport_rect().size / 4
		terminal_scene.get_node("Control/Loadout").set_slots()
		terminal_scene.visible = true
		terminal_scene._ready()
	else:
		camera.position = get_viewport_rect().size / 4
		menu.visible = true
		menu_audio.play()
		if real_scene:
			continue_button.disabled = false
			continue_button.grab_focus()
		else:
			new_game_button. grab_focus()

# quits game when quit button is pressed
func call_quit():
	get_tree().quit()

# instantiates terminal scene and hides + pauses real scene when called
func call_terminal_scene(terminal_name):
	remove_child(real_scene)
	$RealAudio.volume_db = -25
	if terminal_name == "TerminalTestScene":
		terminal_scene = load("res://Scenes/terminal_test_scene.tscn").instantiate()
	else:
		terminal_scene = load("res://Scenes/Levels/" + terminal_name + ".tscn").instantiate()
	add_child(terminal_scene)
	terminal_scene.position = camera.position - get_viewport_rect().size / 4

# returns to real scene when closing terminal
func return_to_real_scene():
	add_child(real_scene)
	$RealAudio.volume_db = -20
	for n in get_tree().get_nodes_in_group("TerminalDoors"):
		n.update_door()

# resets game status and starts Level 1
func new_game():
	await progress_manager.reset_programs()
	call_level(1)

# switches between real levels scenes
func switch_level(level_number):
	remove_child(real_scene)
	real_scene.queue_free()
	call_level(level_number)
	progress_manager.save_point = real_scene.name
	progress_manager.save_game()

# passthrough function from level manager to progress manager adding active real scene to save point
func add_to_levels(level):
	if real_scene == null:
		return
	progress_manager.add_to_levels(level, real_scene.name)

# returns player to game, either to loaded scene or to save point if no scene is loaded
func continue_game():
	if !real_scene:
		await progress_manager.load_game()
		real_scene = load("res://Scenes/Levels/" + progress_manager.save_point + ".tscn").instantiate()
	menu_audio.stop()
	if has_node("RealAudio"):
		$RealAudio.play()
	menu.visible = false
	add_child(real_scene)
