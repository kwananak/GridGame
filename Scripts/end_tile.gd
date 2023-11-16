extends Area2D

@onready var level_manager = $"../../../LevelManager"

func _on_area_entered(_area):
	level_manager.on_end_tile_entered()
