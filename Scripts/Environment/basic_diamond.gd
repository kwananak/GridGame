extends AnimatedSprite2D

var speed
var direction
var level_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	var scale_value = randf_range(0.3, 0.6)
	apply_scale(Vector2(scale_value, scale_value))
	z_index = int(scale_value * 10)
	if level_manager != null:
		position = Vector2(level_manager.camera.position.x + get_viewport_rect().size.x / 4, randf_range(-20.0, level_manager.level_height * level_manager.tile_size))
		speed = randf_range(20.0, 60.0)
	else:
		position = Vector2(500, randf_range(100, 300))
		speed = randf_range(20.0, 40.0)
	direction = Vector2(randf_range(-1.0, -5.0), randf_range(-0.4, 0.4))

func _process(delta):
	position += direction * speed * delta
	if level_manager != null:
		if position.x > level_manager.level_length * level_manager.tile_size || position.y > level_manager.level_height * level_manager.tile_size || position.x < 0 || position.y < -20:
			queue_free()
	else:
		if position.x < 300:
			queue_free()
