extends Node2D

var level_manager

func _ready():
	show()
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if level_manager == null:
		level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	if $/root/Main.real_scene != null:
		match $/root/Main.real_scene.name:
			"Level1":
				$InfoUI.text = "DumpCore\n"
			"Level2":
				$InfoUI.text = "Humanity Diagnostic Mainframe\n"
	$InfoUI.text += $/root/Main.get_level_name(level_manager.level_number)

# relays quit level button press to level manager
func _on_button_pressed():
	level_manager._on_button_pressed()
