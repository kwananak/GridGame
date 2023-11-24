extends Area2D

var tile_type = "program"
var program_slot
var program_type : String

func _ready():
	$AnimatedSprite2D.animation = program_type

# calls progress manager to add picked up program to the list
func pick_up():
	$/root/Main/ProgressManager.add_to_programs(program_slot, program_type)
	queue_free()
