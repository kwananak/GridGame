extends Area2D

var tile_type = "soap"
var moved = false
var target 
var moving = false 
var level_manager
var player
var framed_checker

@onready var ray = $RayCast2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	framed_checker = get_tree().get_first_node_in_group("FramedChecker")

func check_move(player_position):
	ray.target_position = position - player_position
	ray.force_raycast_update()
	if ray.get_collider():
		var collision = ray.get_collider()
		if "tile_type" in collision:
			match collision.tile_type:
				"hole", "chip", "key":
					pass
				_:
					return false
		else:
			return false
	target = ray.target_position
	return true

func hit_by_player(area):
	await _on_area_entered(area)

func _on_area_entered(area):
	if area is int:
		return
	moving = true
	$AudioStreamPlayer2D.play()
	if area is Vector2:
		level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, false)
		await create_tween().tween_property(self, "position", position + area, 1.5/get_tree().get_first_node_in_group("VirtualLevelManager").animation_speed).set_trans(Tween.TRANS_SINE).finished
		level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, true)
		$AnimatedSprite2D.frame = 1
		moved = true
	elif area.is_in_group("Player"):
		ray.target_position = target
		while true:
			ray.force_raycast_update()
			if ray.get_collider():
				var collision = ray.get_collider()
				if "tile_type" in collision:
					match collision.tile_type:
						"hole", "chip", "key":
							pass
						_:
							break
				else:
					break
			level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, false)
			var old_pos = global_position
			position += target
			$AnimatedSprite2D.global_position = old_pos
			await create_tween().tween_property($AnimatedSprite2D, "position", Vector2.ZERO, 0.8 /get_tree().get_first_node_in_group("VirtualLevelManager").animation_speed).set_trans(Tween.TRANS_SINE).finished
			level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, true)
		moved = true
		$AnimatedSprite2D.frame = 1
	moving = false
