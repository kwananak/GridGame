extends "res://Scripts/Managers/progress_manager.gd"

func _ready():
	amplifiers = $Amplifiers

# called by level manager at end of level to add picked up programs
func add_to_programs(slot, program, level):
	for n in get_children():
		if n.name == program.name:
			return
	get_node(slot).add_child(program)
	levels[str(level)]["prog"] = true
