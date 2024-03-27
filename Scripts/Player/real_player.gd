extends CharacterBody2D

const SPEED = 100.0
const inputs = {"left": Vector2.LEFT,
			"right": Vector2.RIGHT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

var level_manager
var active = false
var floating = false
var waiting_for_action = null
var target_move
var target_sprite

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	target_sprite = get_tree().get_first_node_in_group("TargetMoveSprite")
	$AnimatedSprite2D.scale = Vector2.ZERO
	await enter_level_animation()
	active = true

# checks for pause input
func _input(event):
	if level_manager.game_over || !active:
		return
	if event.is_action_pressed("pause"):
		level_manager.press_pause()
	if level_manager.paused:
		return
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == 1:
			target_sprite.frame = 0
			target_move = get_tree().get_first_node_in_group("Camera").position - get_viewport_rect().size / 4 + event.global_position / 2
			target_sprite.position = target_move
			target_sprite.show()

# called when entering a level for a little walk-in animation
func enter_level_animation():
	var level_number = $/root/Main.real_scene.name.substr($/root/Main.real_scene.name.length() -1, -1)
	if int($/root/Main.coming_from) > int(level_number):
		position = get_tree().get_first_node_in_group("EndTile").global_position.snapped(Vector2.ONE * level_manager.tile_size) + Vector2(0, 16)
	else:
		position = get_tree().get_first_node_in_group("StartTile").global_position.snapped(Vector2.ONE * level_manager.tile_size) + Vector2(0, 16)
	await create_tween().tween_property(animated_sprite_2d, "scale", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_SINE).finished
	animated_sprite_2d.play("idle")
	set_collision_layer_value(2, true)

func exit_level(point):
	animated_sprite_2d.play("move")
	if point.global_position.x > global_position.x:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	create_tween().tween_property(animated_sprite_2d, "global_position", point.global_position + Vector2(0, 4), 0.8).set_trans(Tween.TRANS_SINE)
	await create_tween().tween_property(animated_sprite_2d, "scale", Vector2(0.6, 0.6), 0.8).set_trans(Tween.TRANS_SINE).finished
	hide()

func _process(delta):
	if level_manager.game_over || level_manager.paused || !active:
		return
	var input_direction  = Input.get_vector("left", "right", "up", "down")
	if input_direction != Vector2.ZERO:
		target_move = null
	elif target_move:
		if target_move.snapped(Vector2.ONE * 3) == global_position.snapped(Vector2.ONE * 3):
			target_move = null
			return
		input_direction = (target_move - global_position).normalized()
	else:
		target_sprite.hide()
		if animated_sprite_2d.animation != "idle":
			animated_sprite_2d.animation = "idle"
		return
	if input_direction.x < 0:
		animated_sprite_2d.flip_h = true
	if input_direction.x > 0:
		animated_sprite_2d.flip_h = false
	if animated_sprite_2d.animation != "move":
			animated_sprite_2d.animation = "move"
	if !$Footsteps.is_playing():
		$Footsteps.play()
	if move_and_collide(input_direction * SPEED * delta):
		target_move = null
