extends "res://Scripts/Programs/program.gd"

var grapple_range = 5
var tip
var grapple_speed = 1000
var timer_counter = 0
var target_length
var grappling = 0
var grapple_cycle = 0.0
var section_number = 0
var grapple = []

@export var strength = 1
@export var grapple_cycle_reset = 0.01

@onready var grapple_sound = $GrappleSound
@onready var tip_sound = $TipSound
@onready var tip_prefab = preload("res://Scenes/Prefabs/grapple_tip.tscn")
@onready var grapple_section = preload("res://Scenes/Prefabs/grapple_section.tscn")

func _ready():
	type = "QuantumGrapple"
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
	grapple_sound.pitch_scale = 1
	var scene = level_manager.get_parent()
	tip = tip_prefab.instantiate()
	var destination = dir.position / level_manager.tile_size
	match destination.normalized():
		Vector2.DOWN:
			tip.rotation_degrees = 90
			player.animated_sprite_2d.animation = "grapple_down"
			await player.animated_sprite_2d.animation_finished
			scene.add_child(tip)
			tip.global_position = Vector2(player.global_position.x - 0.5, player.global_position.y + 14)
			grapple_sound.play()
			for i in (destination.y - 1) * 4:
				await get_tree().create_timer(1.0 / grapple_speed).timeout
				var section = grapple_section.instantiate()
				grapple.append(section)
				scene.add_child(section)
				section.rotation_degrees = 90
				section.position = Vector2(player.position.x - 0.5, player.position.y + 16 + 8 * i)
				grapple_sound.pitch_scale += 0.02
				tip.position.y += 8
			destination.y -= 1
		Vector2.UP:
			tip.rotation_degrees = 270
			player.animated_sprite_2d.animation = "grapple_up"
			await player.animated_sprite_2d.animation_finished
			scene.add_child(tip)
			tip.global_position = Vector2(player.global_position.x - 0.5, player.global_position.y - 14)
			grapple_sound.play()
			for i in (-destination.y - 1) * 4:
				await get_tree().create_timer(1.0 / grapple_speed).timeout
				tip.position.y -= 8
				var section = grapple_section.instantiate()
				grapple.append(section)
				scene.add_child(section)
				section.rotation_degrees = 90
				section.position = Vector2(player.position.x - 0.5, player.position.y - 16 - 8 * i)
				grapple_sound.pitch_scale += 0.02
			destination.y += 1 
		Vector2.RIGHT:
			player.animated_sprite_2d.animation = "grapple_side"
			await player.animated_sprite_2d.animation_finished
			scene.add_child(tip)
			tip.global_position = Vector2(player.global_position.x + 14, player.global_position.y - 2.5)
			grapple_sound.play()
			for i in (destination.x - 1) * 4:
				await get_tree().create_timer(1.0 / grapple_speed).timeout
				tip.position.x += 8
				var section = grapple_section.instantiate()
				grapple.append(section)
				scene.add_child(section)
				section.position = Vector2(player.position.x + 16 + 8 * i, player.position.y - 2.5)
				grapple_sound.pitch_scale += 0.02
			destination.x -= 1
		Vector2.LEFT:
			tip.rotation_degrees = 180
			player.animated_sprite_2d.animation = "grapple_side"
			await player.animated_sprite_2d.animation_finished
			scene.add_child(tip)
			tip.global_position = Vector2(player.global_position.x - 14, player.global_position.y - 2.5)
			grapple_sound.play()
			for i in (-destination.x - 1) * 4:
				await get_tree().create_timer(1.0 / grapple_speed).timeout
				tip.position.x -= 8
				var section = grapple_section.instantiate()
				grapple.append(section)
				scene.add_child(section)
				section.position = Vector2(player.position.x - 16 - 8 * i, player.position.y - 2.5)
				grapple_sound.pitch_scale += 0.02
			destination.x += 1
	grapple_sound.stop()
	tip_sound.play()
	await get_tree().create_timer(0.1).timeout
	await grapple_resolve(dir, destination)

func grapple_resolve(dir, destination):
	if "tile_type" in dir.available_action:
		match dir.available_action.tile_type:
			"mobile":
				if !dir.available_action.moved:
					grapple_mobile(destination, dir.available_action)
					destination -= destination.normalized()
			"soap":
				if !dir.available_action.moved:
					await grapple_soap(destination, dir.available_action)
					destination = Vector2.ZERO
					remove_grapple(destination)
					player.animated_sprite_2d.play("idle")
					return
			"chip", "key":
				grapple_item(dir.available_action)
				destination = Vector2.ZERO
			"enemy":
				dir.available_action.hit_by_player(strength)
				destination = Vector2.ZERO
			_:
				dir.available_action.hit_by_player(strength)
	remove_grapple(destination)
	await create_tween().tween_property(player, "position", player.position + destination * level_manager.tile_size, 1.5 / (level_manager.animation_speed * 0.9)).set_trans(Tween.TRANS_SINE).finished
	player.animated_sprite_2d.play("idle")

func grapple_mobile(destination, barrier):
	barrier.move(-destination.normalized() * 32)
	grapple_sound.play()
	for n in 4:
		await get_tree().create_timer(1.0 / grapple_speed).timeout
		var section = grapple.pop_back()
		if tip != null:
			tip.position = section.position
		if section != null:
			section.queue_free()
		grapple_sound.pitch_scale -= 0.02

func grapple_soap(destination, barrier):
	var des = destination
	barrier.hit_by_player(-des * level_manager.tile_size)
	grapple_sound.play()
	for n in grapple.size():
		await get_tree().create_timer(1.0 / grapple_speed).timeout
		var section = grapple.pop_back()
		if tip != null:
			tip.position = section.position
		if section != null:
			section.queue_free()
		grapple_sound.pitch_scale -= 0.02
	grapple_sound.stop()

func grapple_item(item):
	item.global_position = tip.global_position
	grapple_sound.play()
	for n in grapple.size():
		await get_tree().create_timer(1.0 / grapple_speed).timeout
		var section = grapple.pop_back()
		if tip != null:
			tip.position = section.position
			item.global_position = tip.global_position
		if section != null:
			section.queue_free()
		grapple_sound.pitch_scale -= 0.02
	grapple_sound.stop()
	if item:
		item.global_position = player.global_position

func remove_grapple(destination):
	grapple_sound.play()
	while !grapple.is_empty():
		await get_tree().create_timer(1.0 / (grapple_speed * 2)).timeout
		if destination != Vector2.ZERO:
			var section = grapple.pop_front()
			if is_instance_valid(section):
				section.queue_free()
		else:
			var section = grapple.pop_back()
			if is_instance_valid(tip) && is_instance_valid(section):
				tip.position = section.position
			if is_instance_valid(section):
				section.queue_free()
		grapple_sound.pitch_scale -= 0.02
	grapple_sound.stop()
	if is_instance_valid(tip):
		tip.queue_free()

func game_over_remove(value):
	if value:
		for n in grapple:
			n.queue_free()
		if is_instance_valid(tip):
			tip.queue_free()
