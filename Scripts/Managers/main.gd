extends Node2D

# scenes
var real_scene
var terminal_scene
var virtual_scene

# menu
var menu
var menu_audio

# buttons
var continue_button
var new_game_button

# real level navigation reference
var coming_from = "0"

@onready var camera = $Camera2D
@onready var progress_manager = $ProgressManager

func _ready():
	set_menu()

func display_splashes():
	var splash = load("res://Scenes/Cutscenes/start_splash.tscn").instantiate()
	add_child(splash)
	await splash.done

# looks for visible menu (main or debug) and adds needed references
func set_menu():
	if $DebugMenu.visible:
		menu = $DebugMenu
		continue_button = $DebugMenu/ContinueGame
		new_game_button = $DebugMenu/VirtualTestLevelButton
		new_game_button.grab_focus()
	else:
		menu = $MainMenu
		await display_splashes()
		menu.visible = true
		continue_button = menu.continue_game
		new_game_button = menu.new_game
		await progress_manager.load_game(null)
		if progress_manager.save_point && !progress_manager.bad_save:
			continue_button.grab_focus()
		else:
			disable_continue()
	menu_audio = menu.get_node("MenuAudio")
	menu_audio.play()
	menu_audio.volume_db = 0.0

# instantiates chosen level
func call_level(level_number):
	menu.visible = false
	var level
	if level_number == 100:
		level = load("res://Scenes/virtual_test_level.tscn").instantiate()
	elif level_number == 0:
		level = load("res://Scenes/real_test_level.tscn").instantiate()
	else:
		level = load("res://Scenes/Levels/Level" + str(level_number) + ".tscn").instantiate()
	if level_number < 100:
		if progress_manager.next_cutscene == level_number:
			progress_manager.next_cutscene += 1
			call_cutscene(level_number)
			if has_node("RealAudio"):
				$RealAudio.stop()
			return
		real_scene = level
	else:
		if has_node("RealAudio"):
			$RealAudio.stop()
		virtual_scene = level
	if terminal_scene:
		if terminal_scene.is_inside_tree():
			remove_child(terminal_scene)
	menu_audio.stop()
	add_child(level)

# restarts loaded level
func retry_level():
	progress_manager.retry_count += 1
	var loaded_virtual_number = virtual_scene.get_node("VirtualLevelManager").level_number
	virtual_scene.queue_free()
	dezoom_camera()
	await get_tree().create_timer(0.05).timeout
	call_level(loaded_virtual_number)

# calls menu from real or virtual scene
func call_menu(level_number):
	if level_number < 100:
		remove_child(real_scene)
		$RealAudio.stop()
	else:
		remove_child(virtual_scene)
	camera.position = get_viewport_rect().size / 4
	menu.visible = true
	menu_audio.play()
	menu_audio.volume_db = 0.0
	continue_button.disabled = false
	continue_button.grab_focus()

# alternative to call_menu function for virtual levels
func menu_from_virtual():
	camera.position = get_viewport_rect().size / 4
	menu.visible = true
	menu_audio.play()
	menu_audio.volume_db = 0.0
	continue_button.disabled = false
	continue_button.grab_focus()

# returns to terminal form virtual scene. if no terminal (ex: debug menu) will return to menu
func back_to_terminal():
	if !terminal_scene:
		call_menu(virtual_scene.get_node("VirtualLevelManager").level_number)
		return
	add_child(terminal_scene)
	virtual_scene.queue_free()
	virtual_scene = null
	$RealAudio.play()
	camera.position = terminal_scene.position + get_viewport_rect().size / 4
	terminal_scene.get_node("Loadout").set_slots()
	terminal_scene.visible = true
	terminal_scene._ready()

# quits game when called. usually from quit button being pressed
func call_quit():
	get_tree().quit()

# instantiates terminal scene and hides + pauses real scene when called
func call_terminal_scene(terminal_name):
	call_deferred("remove_child", real_scene)
	$RealAudio.volume_db = -10
	if terminal_name == "TerminalTestScene":
		terminal_scene = load("res://Scenes/terminal_test_scene.tscn").instantiate()
	else:
		terminal_scene = load("res://Scenes/Levels/" + terminal_name + ".tscn").instantiate()
	await call_deferred("add_child", terminal_scene)
	terminal_scene.position = camera.position - get_viewport_rect().size / 4

# returns to real scene when closing terminal
func return_to_real_scene():
	terminal_scene.queue_free()
	terminal_scene = null
	add_child(real_scene)
	$RealAudio.volume_db = 0
	for n in get_tree().get_nodes_in_group("TerminalDoors"):
		n.update_door()

# resets game status and starts Level 1
func new_game():
	coming_from = "0"
	real_scene = null
	terminal_scene = null
	virtual_scene = null
	await progress_manager.reset_progress()
	if "menu_fade" in menu:
		await menu.menu_fade()
	call_level(1)

# switches between real levels scenes
func switch_level(level_number):
	remove_child(real_scene)
	real_scene.queue_free()
	call_level(level_number)
	progress_manager.save_point = real_scene.name
	progress_manager.save_game()

# passthrough function from level manager to progress manager adding active real scene to save point
func add_to_levels(level_unlocked, level_completed):
	if !real_scene:
		return
	progress_manager.add_to_levels(level_unlocked, real_scene.name, level_completed)

# returns player to game, either to loaded scene or to save point if no scene is loaded
func continue_game():
	if virtual_scene:
		menu_audio.stop()
		menu.visible = false
		add_child(virtual_scene)
		return
	if !real_scene:
		if !progress_manager.save_point:
			await progress_manager.load_game(null)
		real_scene = load("res://Scenes/Levels/" + progress_manager.save_point + ".tscn").instantiate()
	menu_audio.stop()
	if has_node("RealAudio"):
		$RealAudio.play()
	menu.visible = false
	add_child(real_scene)

# starts cutscene
func call_cutscene(cutscene_number):
	menu.visible = false
	if virtual_scene:
		remove_child(virtual_scene)
	camera.add_child(load("res://Scenes/Cutscenes/Cutscene" + str(cutscene_number) + ".tscn").instantiate())

# provided with a level number, retrieves level name from resource file
func get_level_name(level_number):
	if str(level_number) in progress_manager.levels:
		return progress_manager.levels[str(level_number)]["name"]
	else:
		return "name not found"

# disables continue button
func disable_continue():
	continue_button.disabled = true
	new_game_button.grab_focus()

# used in debug menu to call fixed saves for easier testing
func load_fixed_save(save_number):
	real_scene = null
	terminal_scene = null
	virtual_scene = null
	await progress_manager.load_game(save_number)
	real_scene = load("res://Scenes/Levels/" + progress_manager.save_point + ".tscn").instantiate()
	menu_audio.stop()
	if has_node("RealAudio"):
		$RealAudio.play()
	menu.visible = false
	add_child(real_scene)

func dezoom_camera():
	if camera.zoom.x > 2:
		camera.zoom /= 1.2
