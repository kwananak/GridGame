extends Node2D

var progress_manager
var level_manager
var player

@onready var program_bar = $"../UI/ProgramBar"
var camera

func _ready():
	camera = get_tree().get_first_node_in_group("Camera")
	player = get_tree().get_first_node_in_group("Player")
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	activate_program_bar()

func activate_program_bar():
	for n in program_bar.get_children():
		match n.name:
			"Labels", "Sprite2D":
				continue
			_:
				var slot = progress_manager.get_node("Loadout").get_node(str(n.name)).get_children()
				if !slot.is_empty():
					var loaded_program = slot[0].duplicate(15)
					n.add_child(loaded_program)
					loaded_program.loaded()
					loaded_program.monitorable = true
					loaded_program.position = Vector2(-16, 8)
	program_bar.show()
	for n in progress_manager.get_node("OwnedPrograms/Amplifiers").get_children():
		$"../UI/Amplifiers".get_node(n.amplifier_class).show()

func _input(event):
	if player.moving || level_manager.game_over || level_manager.paused || level_manager.dialogue:
		return
	for slot in program_bar.get_children():
		if slot.name == "Labels" || slot.name == "Legs" || slot.name == "Armor" || slot.get_child_count() == 0:
			continue
		var prog = slot.get_child(0)
		if !prog.usable:
			continue
		if event.is_action_pressed(slot.name):
			handle_input(prog)
		if event is InputEventMouseButton:
			if event.is_pressed() && event.button_index == 1:
				if prog.mouse_on:
					handle_input(prog)

func handle_input(prog):
	if player.waiting_for_action:
		if player.waiting_for_action.name != prog.name:
			player.waiting_for_action.cancel_action()
			level_manager.remaining_actions += 1
	if prog.focus:
		prog.cancel_action()
		level_manager.remaining_actions += 1
		return
	if level_manager.remaining_actions > 0 && !prog.focus:
		level_manager.remaining_actions -= 1
		prog.action()
		return
