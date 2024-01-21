extends Node2D

var progress_manager
var level_manager
var activated = false
var player

@onready var program_bar = $"../UI/ProgramBar"

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	activate_program_bar()
	
func activate_program_bar():
	for n in program_bar.get_children():
		match n.name:
			"Labels":
				continue
			_:
				var slot = progress_manager.get_node("Loadout").get_node(str(n.name)).get_children()
				if !slot.is_empty():
					var loaded_program = slot[0].duplicate(15)
					n.add_child(loaded_program)
					loaded_program.loaded()
					loaded_program.monitorable = true
					loaded_program.position = Vector2(-16, 8)
					if loaded_program.active:
						program_bar.get_node("Labels/" + n.name).show()
	program_bar.show()

func _input(event):
	if player.moving:
		return
	for slot in program_bar.get_children():
		if slot.name == "Labels" || slot.name == "Brain":
			continue
		if event.is_action_pressed(slot.name):
			if slot.get_child_count() == 0:
				return
			var prog = slot.get_children()
			if !prog[0].usable:
				return
			if prog[0].focus:
				prog[0].cancel_action()
				level_manager.remaining_actions += 1
				return
			if !prog.is_empty() && level_manager.remaining_actions > 0 && !prog[0].focus:
				level_manager.remaining_actions -= 1
				prog[0].action()