extends Area2D

var level_manager
var player

# set up speed of enemy from inspector. 1 will move every turn, 2 every 2 turn, etc.
@export var speed = 1

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	player = get_tree().get_first_node_in_group("VirtualPlayer")

## Handles level manager's end_turn_call by moving towards next player using level manager's a* grid
func turn_call():
	if level_manager.turn % speed != 0:
		return
	var path = level_manager.astar_grid.get_id_path(Vector2i(position / level_manager.tile_size),
			Vector2i(player.position / level_manager.tile_size))
	if path.is_empty():
		return
	var direction = position.direction_to(path[1] * level_manager.tile_size)
	if direction.x > 0:
		animated_sprite_2d.flip_h = false
	if direction.x < 0:
		animated_sprite_2d.flip_h = true
	level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, false)
	await create_tween().tween_property(self, "position", position + direction * level_manager.tile_size, 1.0/level_manager.animation_speed).set_trans(Tween.TRANS_SINE).finished
	level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, true)

# called when enemy hits player
func _on_area_entered(_area):
	level_manager.call_game_over()
