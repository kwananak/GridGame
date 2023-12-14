extends "res://Scripts/bullet.gd"

var direction

func _ready():
	super._ready()
	label = $Label
	speed = 1
	label.hide()

func turn_call():
	level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, false)
	animated_sprite_2d.frame = 1
	global_position += direction * speed
	animated_sprite_2d.global_position -= direction * speed
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, "global_position",
			global_position,
			1.5/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
	animated_sprite_2d.frame = 0
	if position.x < 0 || position.x > get_viewport_rect().size.x || position.y < 0 || position.y > get_viewport_rect().size.y:
		queue_free()
	level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, true)

func _on_area_entered(area):
	if not "tile_type" in area:
		queue_free()
		return
	match area.tile_type:
		"cannon", "hardened", "enemy":
			area.hit_by_player(1)
			queue_free()
		"bullet", "hole":
			return
		_:
			queue_free()
