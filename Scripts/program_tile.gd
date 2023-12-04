extends Area2D

var tile_type = "program"
var program_slot : String
var program_type : String
var program

func _ready():
	program = load("res://Scenes/Programs/" + program_slot + "/" + program_type +  ".tscn").instantiate()
	add_child(program)

# calls progress manager to add picked up program to the list
func pick_up(_area):
	remove_child(program)
	await $/root/Main/ProgressManager.add_to_programs(program_slot, program)
	get_tree().get_first_node_in_group("MouseToolTip").hide()
	queue_free()
