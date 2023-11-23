extends Area2D

var level_manager
var tile_type = "bullet"
var recalled = false

@onready var animated_sprite_2d = $AnimatedSprite2D


func _ready():
	level_manager = get_tree().get_first_node_in_group("LevelManager")

# called by parent cannon every end of turn
func move_bullet(bullet_speed):
	animated_sprite_2d.frame = 1
	var tween = create_tween()
	tween.tween_property(self, "position",
		position + Vector2.RIGHT * 
			level_manager.tile_size * bullet_speed, 1.0/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
	await tween.finished
	animated_sprite_2d.frame = 0

# checks for collision to either call game over, destroy itself, or continue
func _on_area_entered(area):
	if area.is_in_group("Player"):
		level_manager.call_game_over()
		return
	if not "tile_type" in area:
		queue_free()
		return
	match area.tile_type:
		"cannon", "bullet":
			return
		_:
			queue_free()
