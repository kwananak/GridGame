extends Area2D

var level_manager
var tile_type = "bullet"
var recalled = false
var strength = 1
var speed : set = set_speed

@onready var ray = $RayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D
var label

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	label = animated_sprite_2d.get_node("Label")
	if level_manager.vision:
		label.rotation = -get_parent().get_parent().rotation
		label.global_position += Vector2(-12, -12)
		label.text = str(speed)
		label.show()

# called by parent cannon every end of turn
func move_bullet():
	var old_pos = global_position
	ray.target_position = Vector2.RIGHT * level_manager.tile_size * speed
	ray.force_raycast_update()
	var collision = ray.get_collider()
	if collision:
		if collision.name == "VirtualPlayer":
			global_position = collision.global_position
			animated_sprite_2d.position = old_pos - global_position
	else:
		position += Vector2.RIGHT * level_manager.tile_size * speed
		animated_sprite_2d.position = Vector2.LEFT * level_manager.tile_size * speed
	animate_bullet()

func animate_bullet():
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

func set_speed(value):
	if value < 1:
		speed = 1
	else:
		speed = value
	label.text = str(speed)
