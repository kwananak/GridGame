extends Node2D

var progress_manager
var activated = false

@onready var program_bar = $"../UI/ProgramBar"

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	for n in program_bar.get_children():
		if n.name == "Armor":
			var armor_slot = progress_manager.get_node("Loadout").get_node(str(n.name)).get_children()
			if !armor_slot.is_empty():
				var loaded_program = load("res://Scenes/Programs/" + n.name + "/" + armor_slot[0].name + ".tscn").instantiate()
				n.add_child(loaded_program)
				loaded_program.loaded()
		else:
			n.animation = progress_manager.loadout[n.name]

func _input(event):
	for slot in progress_manager.loadout:
		if slot == "Brain":
			continue
		if event.is_action_pressed(slot):
			print(progress_manager.loadout[slot])
