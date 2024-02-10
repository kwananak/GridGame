extends "res://Scripts/Environment/careful_particle.gd"

var player

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	match randi_range(0, 3):
		0:
			pass
		1:
			pass
		2:
			position = Vector2(level_manager.camera.position.x - get_viewport_rect().size.x / 4, randf_range(level_manager.camera.position.y - get_viewport_rect().size.x / 4, level_manager.camera.position.y + get_viewport_rect().size.x / 4))
		3:
			position = Vector2(level_manager.camera.position.x + get_viewport_rect().size.x / 4, randf_range(-10.0, level_manager.level_height * level_manager.tile_size + 10))
	seeker()

func seeker():
	pass
