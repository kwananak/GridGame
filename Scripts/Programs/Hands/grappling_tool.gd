extends "res://Scripts/Programs/program.gd"

var grapple_range = 5
var grapple = []
var tip

@export var strength = 1

@onready var grapple_sound = $GrappleSound
@onready var tip_sound = $TipSound
@onready var tip_prefab = preload("res://Scenes/Prefabs/grapple_tip.tscn")
@onready var grapple_section = preload("res://Scenes/Prefabs/grapple_section.tscn")


func _ready():
	type = "GrapplingTool"
	info = "Action : Grappling of " + str(grapple_range)
	super._ready()

func loaded():
	active = true
	await super.loaded()
	level_manager.game_over_trigger.connect(game_over_remove)

func action():
	focus = true
	player.waiting_for_action = self
	player.grapple_check(grapple_range)

func cancel_action():
	focus = false
	player.waiting_for_action = null
	player.move_check(player.step)

func confirm_with_dir(dir):
	focus = false
	$LoadedSprite/Button.frame = 1
	await grapple_hit(dir)

# executes grapple towards chosen direction
# deals with player animation and hitting destination (if hittable)
func grapple_hit(dir):
	var scene = level_manager.get_parent()
	tip = tip_prefab.instantiate()
	var destination = dir.position / level_manager.tile_size
	if destination.y > 0:
		tip.global_position = Vector2(player.global_position.x - 0.5, player.global_position.y + 16)
		tip.rotation_degrees = 90
		player.animated_sprite_2d.animation = "grapple_down"
		await player.animated_sprite_2d.animation_finished
		grapple_sound.play()
		scene.add_child(tip)
		for i in (destination.y - 1) * 8:
			await get_tree().create_timer(0.005).timeout
			tip.position.y += 4
			var section = grapple_section.instantiate()
			grapple.append(section)
			scene.add_child(section)
			section.rotation_degrees = 90
			section.position = Vector2(player.position.x - 0.5, player.position.y + 16 + 4 * i)
			grapple_sound.pitch_scale += 0.02
		destination.y -= 1
	elif destination.y < 0:
		tip.global_position = Vector2(player.global_position.x - 0.5, player.global_position.y - 16)
		tip.rotation_degrees = 270
		player.animated_sprite_2d.animation = "grapple_up"
		await player.animated_sprite_2d.animation_finished
		grapple_sound.play()
		scene.add_child(tip)
		for i in (-destination.y - 1) * 8:
			await get_tree().create_timer(0.005).timeout
			tip.position.y -= 4
			var section = grapple_section.instantiate()
			grapple.append(section)
			scene.add_child(section)
			section.rotation_degrees = 90
			section.position = Vector2(player.position.x - 0.5, player.position.y - 16 - 4 * i)
			grapple_sound.pitch_scale += 0.02
		destination.y += 1 
	elif destination.x > 0:
		tip.global_position = Vector2(player.global_position.x + 16, player.global_position.y - 2.5)
		player.animated_sprite_2d.animation = "grapple_side"
		await player.animated_sprite_2d.animation_finished
		grapple_sound.play()
		scene.add_child(tip)
		for i in (destination.x - 1) * 8:
			await get_tree().create_timer(0.005).timeout
			tip.position.x += 4
			var section = grapple_section.instantiate()
			grapple.append(section)
			scene.add_child(section)
			section.position = Vector2(player.position.x + 16 + 4 * i, player.position.y - 2.5)
			grapple_sound.pitch_scale += 0.02
		destination.x -= 1
	elif destination.x < 0:
		tip.global_position = Vector2(player.global_position.x - 16, player.global_position.y - 2.5)
		tip.rotation_degrees = 180
		player.animated_sprite_2d.animation = "grapple_side"
		await player.animated_sprite_2d.animation_finished
		grapple_sound.play()
		scene.add_child(tip)
		for i in (-destination.x - 1) * 8:
			await get_tree().create_timer(0.005).timeout
			tip.position.x -= 4
			var section = grapple_section.instantiate()
			grapple.append(section)
			scene.add_child(section)
			section.position = Vector2(player.position.x - 16 - 4 * i, player.position.y - 2.5)
			grapple_sound.pitch_scale += 0.02
		destination.x += 1
	grapple_sound.stop()
	tip_sound.play()
	await get_tree().create_timer(0.1).timeout
	if "tile_type" in dir.available_action:
		match dir.available_action.tile_type:
			"mobile":
				if !dir.available_action.moved:
					grapple_mobile(destination, dir.available_action)
					destination -= destination.normalized()
			"soap":
				if !dir.available_action.moved:
					grapple_soap(destination, dir.available_action)
					destination = Vector2.ZERO
			"chip", "key":
				grapple_item(dir.available_action)
				destination = Vector2.ZERO
			"enemy":
				dir.available_action.hit_by_player(strength)
				destination = Vector2.ZERO
			_:
				dir.available_action.hit_by_player(strength)
	remove_grapple(destination)
	if destination != Vector2.ZERO:
		await create_tween().tween_property(player, "position", player.position + destination * level_manager.tile_size, 1.5/level_manager.animation_speed).set_trans(Tween.TRANS_SINE).finished
	player.animated_sprite_2d.play("idle")

func grapple_mobile(destination, barrier):
	barrier.grapple_move(-destination.normalized() * 32)
	for n in 8:
		await get_tree().create_timer(0.01).timeout
		var section = grapple.pop_back()
		if tip != null:
			tip.position = section.position
		if section != null:
			section.queue_free()

func grapple_soap(destination, barrier):
	var des = destination
	barrier._on_area_entered(-des * level_manager.tile_size)
	for n in grapple.size():
		await get_tree().create_timer(0.005).timeout
		var section = grapple.pop_back()
		if tip != null:
			tip.position = section.position
		if section != null:
			section.queue_free()

func grapple_item(item):
	item.global_position = tip.global_position
	for n in grapple.size():
		await get_tree().create_timer(0.005).timeout
		var section = grapple.pop_back()
		if tip != null:
			tip.position = section.position
			item.global_position = tip.global_position
		if section != null:
			section.queue_free()

func remove_grapple(destination):
	grapple_sound.play()
	while !grapple.is_empty():
		await get_tree().create_timer(0.005).timeout
		if destination != Vector2.ZERO:
			var section = grapple.pop_front()
			if section != null:
				section.queue_free()
		else:
			var section = grapple.pop_back()
			if tip != null:
				tip.position = section.position
			if section != null:
				section.queue_free()
		grapple_sound.pitch_scale -= 0.01
	grapple_sound.stop()
	if is_instance_valid(tip):
		tip.queue_free()

func game_over_remove(_arg):
	for n in grapple:
		n.queue_free()
	if is_instance_valid(tip):
		tip.queue_free()
