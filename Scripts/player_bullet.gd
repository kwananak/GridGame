extends "res://Scripts/bullet.gd"

var direction

func _ready():
	speed = 1
	super._ready()

func turn_call():
	level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size, false)
	animated_sprite_2d.frame = 1
	var tween = create_tween()
	tween.tween_property(self, "position",
		position + direction * speed, 1.0/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
	await tween.finished
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
		"bullet":
			return
		_:
			queue_free()
