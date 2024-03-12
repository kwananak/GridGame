extends Node2D

var level_manager
var main

func _ready():
	show()
	main = $/root/Main
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if level_manager == null:
		level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	if main.real_scene != null:
		$InfoUI.text = main.get_level_name(main.real_scene.get_node("RealLevelManager").level_number) + "\n"
	$InfoUI.text += main.get_level_name(level_manager.level_number)

# relays quit level button press to level manager
func _on_button_pressed():
	level_manager._on_button_pressed()
