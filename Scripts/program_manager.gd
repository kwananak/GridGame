extends Node2D

var progress_manager
var level_manager
var activated = false

@onready var program_bar = $"../UI/ProgramBar"

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	for n in program_bar.get_children():
		if n.name == "Labels":
			continue
		if n.name == "Armor":
			var armor_slot = progress_manager.get_node("Loadout").get_node(str(n.name)).get_children()
			if !armor_slot.is_empty():
				var loaded_program = armor_slot[0].duplicate(15)
				n.add_child(loaded_program)
				loaded_program.loaded()
		else:
			n.animation = progress_manager.loadout[n.name]
	program_bar.show()

func _input(event):
	for slot in program_bar.get_children():
		if slot.name == "Labels":
			continue
		if event.is_action_pressed(slot.name):
			var prog = slot.get_children()
			if !prog.is_empty() && level_manager.remaining_actions > 0:
				level_manager.remaining_actions -= 1
				prog[0].action()
