extends "res://Scripts/player.gd"

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	enter_level_animation()

### needs major change ###
# grid-based movements, needs to be changed to free roam
func move(dir):
		moving = true
		var tween = create_tween()
		tween.tween_property(self, "position",
				position + inputs[dir] * level_manager.tile_size,
				1.5/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
		await tween.finished
		await level_manager.end_turn(level_manager.turn + 1)
		moving = false

# called when entering a level for a little walk-in animation
func enter_level_animation():
	moving = true
	position = get_tree().get_first_node_in_group("StartTile").position.snapped(Vector2.ONE * level_manager.tile_size)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_SINE)
	await tween.finished
	moving = false

# checks for collision before moving or taking appropriate action
func collision_check(dir):
	ray.target_position = inputs[dir] * level_manager.tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		move(dir)
	else:
		var collision = ray.get_collider()
		if collision.is_in_group("Terminal"):
			level_manager.call_terminal()
			return
		match collision.tile_type:
			"door":
				if collision.unlocked: 
					collision.open_door()
					move(dir)
