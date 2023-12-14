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
	await program.picked_up(program_slot)
	remove_child(program)
	queue_free()
