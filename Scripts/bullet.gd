extends Area2D

var level_manager
var tile_type = "bullet"
var recalled = false
var strength = 1
var speed : set = set_speed

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

# called by parent cannon every end of turn
func move_bullet():
	position += Vector2.RIGHT * level_manager.tile_size * speed
	animate_bullet()

func animate_bullet():
	animated_sprite_2d.position = Vector2.LEFT * level_manager.tile_size * speed
	animated_sprite_2d.frame = 1
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, "position",
		Vector2.ZERO, 1.0/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
	await tween.finished
	animated_sprite_2d.frame = 0

# checks for collision to either call game over, destroy itself, or continue
func _on_area_entered(area):
	if area.is_in_group("VirtualPlayer"):
		if !level_manager.invincible && !level_manager.is_immune_to_bullets:
			level_manager.health -= strength
		queue_free()
	if not "tile_type" in area:
		queue_free()
		return
	match area.tile_type:
		"cannon", "bullet":
			return
		_:
			queue_free()

func set_speed(value):
	if value < 1:
		speed = 1
	else:
		speed = value
