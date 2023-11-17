extends Area2D

var tile_type = "bullet"
var recalled = false

@onready var animated_sprite_2d = $"AnimatedSprite2D"
@onready var level_manager = $"../../../../LevelManager"

func move_bullet():
	var tween = create_tween()
	tween.tween_property(self, "position",
		position + Vector2.RIGHT * 
			level_manager.tile_size * $"../..".bullet_speed, 1.0/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
	await tween.finished

func _on_area_entered(area):
	if not "tile_type" in area:
		queue_free()
		return
	match area.tile_type:
		"cannon", "bullet":
			return
		"player":
			level_manager.call_game_over()
		_:
			queue_free()
