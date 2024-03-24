extends Area2D

var level_manager
var is_destroyed = false
var tile_type = "enemy"
var framed_checker
var shield_count
var hitted = false

# add path nodes and set speed from inspector. 1 will move every turn, 2 every 2 turn, etc.
@export var path_nodes : Array[Node] = []
@export var speed = 1
@export var shielded = true
@export var shield_recharge = 4

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var move = $Move
@onready var hit = $Hit
@onready var shield_prefab = preload("res://Scenes/Prefabs/path_enemy_shield.tscn")

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	framed_checker = get_tree().get_first_node_in_group("FramedChecker")
	if shielded:
		shield_count = shield_recharge
		create_shield()
	animated_sprite_2d.frame = randi_range(0, animated_sprite_2d.sprite_frames.get_frame_count("idle") - 1)
	await get_tree().create_timer(0.2).timeout
	if level_manager.vision:
		$Sprite2D.global_position = global_position.direction_to(path_nodes[0].global_position)
		$Sprite2D.show()

## Handles level manager's end_turn_call by moving towards next node on path
func turn_call():
	while hitted:
		await get_tree().create_timer(0.01).timeout
	shield_check()
	if level_manager.turn % speed !=0:
		return
	$Sprite2D.hide()
	var direction = path_find()
	if !direction:
		return
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
	var frame = animated_sprite_2d.frame
	animated_sprite_2d.animation = "move"
	await create_tween().tween_property(animated_sprite_2d, "position", Vector2.ZERO, 1.5/level_manager.animation_speed).set_trans(Tween.TRANS_SINE).finished
	animated_sprite_2d.animation = "idle"
	animated_sprite_2d.frame = frame
	if level_manager.vision:
		$Sprite2D.show()

func path_find():
	if path_nodes.is_empty():
		return
	if path_nodes[0].global_position == global_position:
		path_nodes.push_back(path_nodes.pop_front())
	var path = level_manager.astar_grid.get_id_path(Vector2i(position / level_manager.tile_size), Vector2i(path_nodes[0].global_position / level_manager.tile_size))
	if path.size() < 2:
		return
	return position.direction_to(path[1] * level_manager.tile_size)

func cycle_path():
	if position == path_nodes[0].global_position:
		path_nodes.push_back(path_nodes.pop_front())
	$Sprite2D.position = position.direction_to(path_nodes[0].global_position) * level_manager.tile_size

func shield_check():
	if shielded || !shield_count:
		return
	shield_count -= 1
	if shield_count < 1:
		shield_count = shield_recharge
		shielded = true
		create_shield()

func create_shield():
	$AnimatedSprite2D.add_child(shield_prefab.instantiate())
	await $AnimatedSprite2D/Shield.animation_finished
	$AnimatedSprite2D/Shield.animation = "default"

func remove_shield():
	$AnimatedSprite2D/Shield.play("pop")
	await $AnimatedSprite2D/Shield.animation_finished
	$AnimatedSprite2D/Shield.queue_free()

func _on_area_entered(area):
	if is_destroyed:
		return
	if area.is_in_group("VirtualPlayer"):
		level_manager.call_game_over()
		return
	hit_by_player(3)

func hit_by_player(strength):
	if is_destroyed:
		return
	hitted = true
	if framed_checker.check(global_position):
		hit.play()
	var frame = animated_sprite_2d.frame
	animated_sprite_2d.play("hit")
	await get_tree().create_timer(0.1).timeout
	if strength is Node:
		if strength.is_in_group("VirtualPlayer"):
			level_manager.health -= 1
			match global_position.direction_to(strength.global_position):
				Vector2.LEFT:
					animated_sprite_2d.flip_h = true
				Vector2.RIGHT:
					animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("counter")
			await animated_sprite_2d.animation_finished
			animated_sprite_2d.play("idle")
			animated_sprite_2d.frame = frame
	if shielded: 
		shielded = false
		remove_shield()
	else:
		animated_sprite_2d.play("destroyed")
		level_manager.astar_grid.set_point_solid(Vector2i(global_position) / level_manager.tile_size, true)
		is_destroyed = true
		animated_sprite_2d.frame = 1
		$Sprite2D.hide()
		remove_from_group("EndTurn")
	hitted = false
