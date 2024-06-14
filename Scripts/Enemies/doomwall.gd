extends Area2D

var level_manager
var camera
var label
var player
var state = "default" : set = set_state

var freeze = 0 : set = set_freeze
var adjustment = 0
var skip_turn = false
var step
var distance_to_player
var section_number = 0
var warning_ui

@onready var section_prefab = preload("res://Scenes/Prefabs/doomwall_section.tscn")
@onready var sprite = $AnimatedSprites
@onready var audio = $AudioStreamPlayer2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	camera = get_tree().get_first_node_in_group("Camera")
	label = get_tree().get_first_node_in_group("FirewallLabel")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	warning_ui = get_tree().get_first_node_in_group("WarningUI")
	set_collision_shape()
	step = level_manager.green_doomwall_step
	level_manager.doomwall_state_changed.connect(set_state)
	vision_check()

func _process(delta):
	if level_manager.vision:
		update_vision(delta)
	if position.x - section_number * level_manager.tile_size > camera.position.x - get_viewport_rect().size.x / 4 - 32:
		create_wall_sprite()

func create_wall_sprite():
	var height = level_manager.level_height
	if height < get_viewport_rect().size.y / level_manager.tile_size:
		height = get_viewport_rect().size.y / level_manager.tile_size
	for h in height / 8:
		var section = section_prefab.instantiate()
		sprite.add_child(section)
		section.position = Vector2(16 - section_number * level_manager.tile_size, h * level_manager.tile_size * 8)
		section.animation = state
		section.frame = section_number % 3
		section.modulate.a = 1 - 0.1 * section_number
		if section.modulate.a < 0.2:
			section.modulate.a = 0.2
	section_number += 1

func set_collision_shape():
	$CollisionShape2D.shape.size = Vector2(30, level_manager.level_height * level_manager.tile_size)
	$CollisionShape2D.position = Vector2(16, 16 + (level_manager.level_height * level_manager.tile_size / 2))

func update_vision(delta):
	label.show()
	label.text = str(distance_to_player)
	var target = Vector2(position.x + 20, camera.position.y - get_viewport_rect().size.y / 4 + 40)
	if position.x < camera.position.x - get_viewport_rect().size.x / 4:
		target.x = camera.position.x - get_viewport_rect().size.x / 4 + 20
	label.global_position = label.global_position.move_toward(target, delta * 300)

# moves wall right when called by level manager
func turn_call():
	if freeze > 0:
		freeze -= 1
		adjustment -= 1
		vision_check()
		return
	if skip_turn:
		skip_turn = false
		vision_check()
		return
	move_wall(step)

# called when firewall hits player
func _on_area_entered(area):
	if area.is_in_group("VirtualPlayer"):
		level_manager.call_game_over()

# called to change wall position out of turn call
func move_wall(distance):
	if distance == 0:
		return
	if distance < 0:
		audio.pitch_scale = 0.9
	else:
		audio.pitch_scale = 1
		audio.position.y = player.global_position.y
	audio.play()
	var pos = global_position
	if distance > 0.0:
		for n in distance / 0.5:
			global_position.x += 0.5 * level_manager.tile_size
			sprite.global_position = pos
	else:
		for n in distance / -0.5:
			global_position.x -= 0.5 * level_manager.tile_size
			sprite.global_position = pos
	await create_tween().tween_property(sprite, "position", Vector2.ZERO, 1.5 / level_manager.animation_speed).set_trans(Tween.TRANS_SINE).finished
	vision_check()

func vision_check():
	if step == 0 || !level_manager.cyber:
		distance_to_player = ""
	else:
		distance_to_player = (player.global_position.x - global_position.x - 32) / level_manager.tile_size / step
		if distance_to_player > int(distance_to_player):
			distance_to_player = int(distance_to_player + 1)
		if distance_to_player < 5:
			warning_ui.get_node("AnimationPlayer").play("pulse")
		else:
			warning_ui.get_node("AnimationPlayer").stop()
	warning_ui.get_node("Label").text = str(distance_to_player)

func fade_out():
	create_tween().tween_property($AudioStreamPlayer2D, "volume_db", -80, 1)

func set_state(value):
	state = value
	match state:
		"careful":
			step = level_manager.yellow_doomwall_step
			warning_ui.play("yellow")
			warning_ui.get_node("Label").show()
			$AudioStreamPlayer.pitch_scale = 0.8
		"danger":
			step = level_manager.red_doomwall_step
			warning_ui.play("red")
			warning_ui.get_node("Label").position.x += 22
			warning_ui.get_node("Label").show()
			$AudioStreamPlayer.pitch_scale = 1.0
		"extreme":
			step = level_manager.aqua_doomwall_step
			warning_ui.play("aqua")
			warning_ui.get_node("Label").hide()
			$AudioStreamPlayer.pitch_scale = 1.2
	$AudioStreamPlayer.play()
	for n in sprite.get_children():
		var frame = n.frame
		n.animation = state
		n.frame = frame

func set_freeze(value):
	freeze = value
	if freeze:
		$Freeze.play()
	if freeze > 0:
		for n in sprite.get_children():
			var frame = n.frame
			n.animation = state + "freeze"
			n.frame = frame
	else:
		for n in sprite.get_children():
			var frame = n.frame
			n.animation = state
			n.frame = frame
