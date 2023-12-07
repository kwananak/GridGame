extends Area2D

var level_manager
var is_destroyed = false
var tile_type = "enemy"

# add path nodes and set speed from inspector. 1 will move every turn, 2 every 2 turn, etc.
@export var path_nodes : Array[Node] = []
@export var speed = 1

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

## Handles level manager's end_turn_call by moving towards next node on path
func turn_call():
	if level_manager.turn % speed !=0:
		return
	if position == path_nodes[0].position:
		path_nodes.push_back(path_nodes.pop_front())
	var direction = position.direction_to(path_nodes[0].position)
	match direction:
		Vector2.LEFT:
			animated_sprite_2d.flip_h = true
		Vector2.RIGHT:
			animated_sprite_2d.flip_h = false
	var tween = create_tween()
	tween.tween_property(self, "position",
		position + direction * 
			level_manager.tile_size, 1.0/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
	await tween.finished

# called when enemy hits player
func _on_area_entered(_area):
	if is_destroyed:
		return
	level_manager.call_game_over()

func hit_by_player(_strength):
	if is_destroyed:
		return
	is_destroyed = true
	level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, true)
	animated_sprite_2d.frame = 1
	remove_from_group("EndTurn")
