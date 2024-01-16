extends Node2D

var level_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if level_manager == null:
		level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	$InfoUI.text = get_parent().name

# relays quit level button press to level manager
func _on_button_pressed():
	level_manager._on_button_pressed()
