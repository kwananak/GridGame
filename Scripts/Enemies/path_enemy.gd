extends Area2D

var level_manager
var is_destroyed = false
var tile_type = "enemy"
var framed_checker

# add path nodes and set speed from inspector. 1 will move every turn, 2 every 2 turn, etc.
@export var path_nodes : Array[Node] = []
@export var speed = 1

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var move = $Move
@onready var hit = $Hit

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	framed_checker = get_tree().get_first_node_in_group("FramedChecker")
	await get_tree().create_timer(0.2).timeout
	if level_manager.vision:
		$Sprite2D.global_position = global_position.direction_to(path_nodes[0].global_position)
		$Sprite2D.show()

## Handles level manager's end_turn_call by moving towards next node on path
func turn_call():
	if level_manager.turn % speed !=0 || path_nodes.is_empty():
		return
	$Sprite2D.hide()
	var path = level_manager.astar_grid.get_id_path(Vector2i(position / level_manager.tile_size), Vector2i(path_nodes[0].position / level_manager.tile_size))
	while path.size() < 2:
		path_nodes.push_back(path_nodes.pop_front())
		path = level_manager.astar_grid.get_id_path(Vector2i(position / level_manager.tile_size), Vector2i(path_nodes[0].position / level_manager.tile_size))
	var direction = position.direction_to(path[1] * level_manager.tile_size)
	match direction:
		Vector2.LEFT:
			animated_sprite_2d.flip_h = true
		Vector2.RIGHT:
			animated_sprite_2d.flip_h = false
	if framed_checker.check(global_position):
		move.play()
	var old_pos = animated_sprite_2d.global_position
	level_manager.astar_grid.set_point_solid(Vector2i(global_position) / level_manager.tile_size, false)
	position += direction * level_manager.tile_size
	level_manager.astar_grid.set_point_solid(Vector2i(global_position) / level_manager.tile_size, true)
	animated_sprite_2d.global_position = old_pos
	create_tween().tween_property(animated_sprite_2d, "position", Vector2.ZERO, 1.0/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
	if position == path_nodes[0].global_position:
		path_nodes.push_back(path_nodes.pop_front())
	$Sprite2D.position = position.direction_to(path_nodes[0].global_position) * level_manager.tile_size
	if level_manager.vision:
		$Sprite2D.show()

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
	$Sprite2D.hide()
	remove_from_group("EndTurn")
