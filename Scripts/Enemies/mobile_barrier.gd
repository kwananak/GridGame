extends Area2D

var tile_type = "mobile"
var moved = false
var target
var level_manager

@onready var ray = $RayCast2D
@onready var sprite = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

func check_move(player_position):
	ray.target_position = position - player_position
	ray.force_raycast_update()
	if ray.get_collider():
		return false
	target = ray.target_position
	return true

func move(direction):
	if moved:
		return
	moved = true
	audio.play()
	var old_pos = global_position
	level_manager.astar_grid.set_point_solid(Vector2i(global_position) / level_manager.tile_size, false)
	position += direction
	level_manager.astar_grid.set_point_solid(Vector2i(global_position) / level_manager.tile_size, true)
	sprite.global_position = old_pos
	create_tween().tween_property(sprite, "position", Vector2.ZERO, 1.5/get_tree().get_first_node_in_group("VirtualLevelManager").animation_speed).set_trans(Tween.TRANS_SINE)
	sprite.frame = 1

func _on_area_entered(_area):
	moved = true
	sprite.frame = 1

func hit_by_player(_hit):
	await move(target)
