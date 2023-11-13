extends Node2D

@onready var level_manager = $"../LevelManager" 

# relays quit level button press to level manager
func _on_button_pressed():
	level_manager._on_button_pressed()
