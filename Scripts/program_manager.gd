extends Node2D

var progress_manager
var level_manager
var activated = false

@onready var program_bar = $"../UI/ProgramBar"

func _ready():
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
					loaded_program.position = Vector2.ZERO
					n.add_child(loaded_program)
					loaded_program.loaded()
	program_bar.show()

func _input(event):
	for slot in program_bar.get_children():
		if slot.name == "Labels" || slot.name == "Brain":
			continue
		if event.is_action_pressed(slot.name):
			var prog = slot.get_children()
			if !prog.is_empty() && level_manager.remaining_actions > 0:
				if prog[0].usable:
					level_manager.remaining_actions -= 1
					prog[0].action()
