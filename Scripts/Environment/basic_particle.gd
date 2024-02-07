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
	if level_manager != null:
		level_manager.pause_trigger.connect(set_pause)
		position = Vector2(level_manager.camera.position.x + get_viewport_rect().size.x / 4, randf_range(-10.0, level_manager.level_height * level_manager.tile_size + 10))
	else:
		position = Vector2(500, randf_range(100, 400))
	speed = randf_range(10.0, 20.0) / (1.0 - scale_value)
	direction = Vector2(randf_range(-1.0, -5.0), randf_range(-0.4, 0.4))
	await get_tree().create_timer(0.1).timeout
	if scale_value < 0.4:
		animation = "back_layer"
	#spinner()

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
		if position.x > level_manager.level_length * level_manager.tile_size || position.y > level_manager.level_height * level_manager.tile_size || position.x < 0 || position.y < -20:
			queue_free()
	else:
		if position.x < 300:
			queue_free()

func set_pause(value):
	paused = value

func spinner():
	while true:
		await get_tree().create_timer(randf_range(0.5, 1.0)).timeout
		var spin_dice = randf_range(0.3, 0.6)
		if randf_range(0.0, 2.0) < 1.0:
			spin = spin_dice
		else:
			spin = -spin_dice
