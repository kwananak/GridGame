extends "res://Scripts/Enemies/enemy.gd"

var player

# set up speed of enemy from inspector. 1 will move every turn, 2 every 2 turn, etc.
@export var activated = false
@export var seeker_number = 0

func turn_call():
	if activated:
		await super.turn_call()

func _ready():
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	super._ready()
	shield_prefab = preload("res://Scenes/Prefabs/seeker_enemy_shield.tscn")

## Handles level manager's end_turn_call by moving towards next player using level manager's a* grid
func path_find():
	var path = level_manager.astar_grid.get_id_path(Vector2i(global_position / level_manager.tile_size),
			Vector2i(player.global_position / level_manager.tile_size))
	if path.size() < 2:
		return
	return global_position.direction_to(path[1] * level_manager.tile_size)

func cycle_path():
	pass
