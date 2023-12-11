extends Area2D

var tile_type = "hardened"
var level_manager

# set up the strength of the tile from the inspector
@export var strength = 1

# calls _match_strength when game starts
func _ready():
	match_strength()
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

# matches visual to strength
func match_strength():
	if strength <= 0:
		level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, false)
		queue_free()
	else:
		$AnimatedSprite2D.frame = strength - 1

# called when player hits the tile
func hit_by_player(hit):
	if hit is Object:
		strength = 0
	else:
		strength -= hit
	match_strength()
