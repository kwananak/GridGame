extends AnimatedSprite2D

var speed
var direction
var level_manager
var paused = false
var flip_switch = false
var spin = 0.0

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	var scale_value = randf_range(0.3, 0.6)
	apply_scale(Vector2(scale_value, scale_value))
	z_index = int(scale_value * 10)
	rotation_degrees = randf_range(0, 360)
	if level_manager != null:
		level_manager.pause_trigger.connect(set_pause)
		global_position = Vector2(level_manager.camera.global_position.x + get_viewport_rect().size.x / 4, randf_range(level_manager.camera.global_position.y - get_viewport_rect().size.y / 4, level_manager.camera.global_position.y + get_viewport_rect().size.y / 4))
	else:
		global_position = Vector2(500, randf_range(100, 400))
	speed = randf_range(10.0, 20.0) / (1.0 - scale_value)
	direction = Vector2(randf_range(-1.0, -5.0), randf_range(-0.4, 0.4))
	await get_tree().create_timer(0.1).timeout
	if scale_value < 0.4:
		animation = "back_layer"

func _process(delta):
	if paused:
		if flip_switch:
			position -= direction * speed * delta
		else:
			position += direction * speed * delta
		flip_switch = !flip_switch
		return
	position += direction * speed * delta
	rotation += spin * delta
	if level_manager != null:
		if global_position.x > level_manager.level_length * level_manager.tile_size || global_position.y > level_manager.level_height * level_manager.tile_size || global_position.x < 0 || global_position.y < -20:
			queue_free()
	else:
		if position.x < 300:
			queue_free()

func set_pause(value):
	paused = value
