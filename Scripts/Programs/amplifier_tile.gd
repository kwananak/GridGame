extends "res://Scripts/Programs/program_tile.gd"

@export_enum("NeuroEnhanceAmplifier1", "NeuroEnhanceAmplifier2", "NeuroEnhanceAmplifier3", "NeuroEnhanceAmplifier4") var select_amplifier : String

func _ready():
	for n in get_tree().get_first_node_in_group("ProgressManager").get_node("OwnedPrograms/Amplifiers").get_children():
		if n.name == select_amplifier:
			queue_free()
			return
	program_type = select_amplifier
	program_slot = "Amplifiers"
	super._ready()

func pick_up(_area):
	program.scale = Vector2.ONE
	program.set_deferred("monitorable", false)
	get_tree().get_first_node_in_group("MouseToolTip").hide()
	$AnimatedSprite2D.remove_child(program)
	get_tree().get_first_node_in_group("ProgressManager").add_amplifier(program)
	queue_free()
