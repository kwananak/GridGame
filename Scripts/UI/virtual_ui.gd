extends Node2D

var level_manager
var main

# Called when the node enters the scene tree for the first time.
func _ready():
	show()
	main = $/root/Main
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if main.real_scene != null:
		$InfoUI.text = main.get_level_name(main.real_scene.get_node("RealLevelManager").level_number) + "\n"
	$InfoUI.text += main.get_level_name(level_manager.level_number)
