extends Area2D

var tile_type = "enemy" 
var is_destroyed = false
var level_manager
var player
var framed_checker

# set up speed of enemy from inspector. 1 will move every turn, 2 every 2 turn, etc.
@export var speed = 1
@export var activated = false
@export var seeker_number = 0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var move = $Move
@onready var hit = $Hit

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	framed_checker = get_tree().get_first_node_in_group("FramedChecker")

## Handles level manager's end_turn_call by moving towards next player using level manager's a* grid
func turn_call():
	if level_manager.turn % speed != 0 || !activated:
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
	if framed_checker.check(global_position):
		move.play()
	var old_pos = animated_sprite_2d.global_position
	level_manager.astar_grid.set_point_solid(Vector2i(global_position) / level_manager.tile_size, false)
	position += direction * level_manager.tile_size
	level_manager.astar_grid.set_point_solid(Vector2i(global_position) / level_manager.tile_size, true)
	animated_sprite_2d.global_position = old_pos
	create_tween().tween_property(animated_sprite_2d, "position", Vector2.ZERO, 1.0/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)

func _on_area_entered(area):
	if is_destroyed:
		return
	if area.is_in_group("VirtualPlayer"):
		level_manager.call_game_over()
		return
	hit_by_player(3)

func hit_by_player(_strength):
	if is_destroyed:
		return
	if framed_checker.check(global_position):
		hit.play()
	is_destroyed = true
	animated_sprite_2d.frame = 1
	remove_from_group("EndTurn")
