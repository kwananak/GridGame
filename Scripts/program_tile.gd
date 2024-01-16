extends Area2D

var tile_type = "program"
var program_slot : String
var program_type : String
var program

func _ready():
	program = load("res://Scenes/Programs/" + program_slot + "/" + program_type +  ".tscn").instantiate()
	add_child(program)
	program.monitorable = true

# calls progress manager to add picked up program to the list
func pick_up(_area):
	program.set_deferred("monitorable", false)
	get_tree().get_first_node_in_group("VirtualLevelManager").programs += [[program_slot, program]]
	get_tree().get_first_node_in_group("MouseToolTip").hide()
	remove_child(program)
	queue_free()
