extends "res://Scripts/Player/player.gd"

enum Actions {MOVE, HIT, NONE}
const all_dir = [Vector2(0, 1),
	Vector2(-1, 1),
	Vector2(-1, 0),
	Vector2(-1, -1),
	Vector2(0, -1),
	Vector2(1, -1),
	Vector2(1, 0),
	Vector2(1, 1)
]

var attack_distance = 1
var strength = 1
var step = 1
var possible_moves
var row_checker
var teleport = false
var saved_frame = 0

@onready var grapple_tip = preload("res://Scenes/Prefabs/grapple_tip.tscn")
@onready var grapple_section = preload("res://Scenes/Prefabs/grapple_section.tscn")

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	possible_moves = $PossibleMoves.get_children()
	row_checker = $RowChecker
	await enter_level_animation()
	move_check(step)

func _physics_process(_delta):
	get_input()

# checks for pressed or held direction keys
func get_input():
	if level_manager.game_over || level_manager.paused || moving:
		return
	for dir in inputs.keys():
		var dir_node = get_node("PossibleMoves/" + dir)
		if Input.is_action_pressed(dir):
			moving = true
			match dir:
				"left":
					animated_sprite_2d.flip_h = true
				"right":
					animated_sprite_2d.flip_h = false
			if dir_node.available_action != null:
				act(dir_node)
			elif dir_node.possible:
				move(dir_node.global_position)
			else:
				moving = false

func _unhandled_input(event):
	if level_manager.game_over:
		return 
	if event.is_action_pressed("pause"):
		level_manager.press_pause()
	if event.is_action_pressed("skip_turn"):
		if level_manager.dialogue:
			level_manager.dialogue.close()
		else:
			if !moving && !level_manager.paused:
				skip_turn()
	if level_manager.paused:
		return
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == 1:
			for n in $PossibleMoves.get_children():
				if n.moused:
					moving = true
					match n.name:
						"left":
							animated_sprite_2d.flip_h = true
						"right":
							animated_sprite_2d.flip_h = false
					if n.possible:
						move(n.global_position)
					elif n.available_action != null:
						act(n)
					else:
						moving = false

# self explanatory
func skip_turn():
	moving = true
	for n in possible_moves:
		n.reset()
	await level_manager.end_turn()

# triggers action on selected direction
func act(dir):
	moving = true
	for n in possible_moves:
		n.hide()
	if !waiting_for_action:
		play_hit()
		await dir.available_action.hit_by_player(strength)
	else:
		match waiting_for_action.name:
			dir.available_action.name, "GrapplingTool":
				await waiting_for_action.confirm_with_dir(dir)
			_:
				if waiting_for_action != null:
					await waiting_for_action.cancel_action() 
	for n in possible_moves:
		n.reset()
	waiting_for_action = null
	await get_tree().create_timer(0.1).timeout
	await level_manager.end_turn()

func play_hit():
	animated_sprite_2d.animation = "hit"
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.animation = "idle"
	animated_sprite_2d.play()

# grid based character movement to available checked locations
func move(pos):
	moving = true
	for n in possible_moves:
		n.reset()
	if teleport:
		hide()
		await get_tree().create_timer(0.1).timeout
		var tween = create_tween().tween_property(self, "position",
				pos,
				1.5/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
		animated_sprite_2d.play("move")
		await tween.finished
		await get_tree().create_timer(0.1).timeout
		show()
	else:
		var old_pos = position
		position = pos
		animated_sprite_2d.position = old_pos - position
		var tween = create_tween().tween_property(animated_sprite_2d, "position",
				Vector2.ZERO,
				1.5/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
		$Footsteps.play()
		animated_sprite_2d.play("move")
		animated_sprite_2d.frame = saved_frame
		await tween.finished
		saved_frame = animated_sprite_2d.frame
		animated_sprite_2d.play("idle")
		$Footsteps.stop()
	if waiting_for_action != null:
		waiting_for_action.confirm()
		waiting_for_action = null
	level_manager.end_turn()

# check for available location for player movement or action
func move_check(distance):
	moving = true
	if level_manager.game_over:
		return
	for n in possible_moves:
		n.reset()
	if attack_distance > step && waiting_for_action == null:
		attack_check()
		return
	for n in possible_moves:
		if teleport:
			ray.target_position = n.dir * (level_manager.tile_size * 1.5)
			ray.position = n.dir * level_manager.tile_size * (distance - 1)
			ray.force_raycast_update()
			if ray.get_collider():
				continue
			n.position = n.dir * (level_manager.tile_size * distance)
			n.possible = true
		else:
			ray.target_position = n.dir * (level_manager.tile_size * 1.5)
			for i in distance:
				ray.position = n.dir * level_manager.tile_size * i
				ray.force_raycast_update()
				var collision = ray.get_collider()
				if collision:
					n.check_collision(collision)
					if !n.available_action && !n.possible:
						if i > 0:
							n.position = n.dir * level_manager.tile_size * i
							n.possible = true
						break
					if n.available_action:
						n.position = n.dir * level_manager.tile_size * (i + 1)
						break
				if i == distance - 1:
					n.position = n.dir * level_manager.tile_size * distance
					n.possible = true
	moving = false

# checks for attacks when attack distance is further than move distance
func attack_check():
	for n in possible_moves:
		ray.target_position = n.dir * (level_manager.tile_size * 1.5)
		for i in attack_distance:
			ray.position = n.dir * level_manager.tile_size * i
			ray.force_raycast_update()
			var collision = ray.get_collider()
			if collision:
				n.position = n.dir * level_manager.tile_size * (i + 1)
				await n.check_collision(collision)
				if n.available_action == null && i > 0:
					n.position = n.dir * (level_manager.tile_size * step)
					n.possible = true
				break
			if i == attack_distance - 1:
				n.position = n.dir * (level_manager.tile_size * step)
				n.possible = true
	moving = false

# check for row attacks
func row_check(distance):
	moving = true
	for n in possible_moves:
		n.reset()
	for n in possible_moves:
		ray.target_position = n.dir * (level_manager.tile_size * 1.5)
		for i in distance:
			ray.position = n.dir * level_manager.tile_size * i
			ray.force_raycast_update()
			var collision = ray.get_collider()
			if collision:
				n.check_collision(collision)
				if n.available_action != null:
					var new_check = n.duplicate(15)
					new_check.position = n.dir * level_manager.tile_size * (i + 1)
					new_check.available_action = collision
					new_check.add_to_group(n.name)
					row_checker.add_child(new_check)
					n.available_action = waiting_for_action
					n.hide()
	moving = false

# executes the row attack
func row_hit(dir):
	for n in row_checker.get_children():
		if n.is_in_group(dir.name):
			n.available_action.hit_by_player(strength)
	clean_row_checker()
	level_manager.end_turn()

# removes all point from row checker
func clean_row_checker():
	moving = true
	for n in row_checker.get_children():
		n.queue_free()

# checks for available directions for projectile
func projectile_check(program):
	move_check(step)
	for n in possible_moves:
		if n.shootable:
			if n.available_action == null:
				n.position += n.dir * level_manager.tile_size
			n.available_action = program
		elif n.available_action != null:
			n.available_action = null
		if n.possible:
			n.possible = false
			n.available_action = program
	moving = false

# hits a tile away in all direction
func circle_hit(whip):
	moving = true
	for n in possible_moves:
		n.hide()
	animated_sprite_2d.animation = "circle_whip"
	await animated_sprite_2d.animation_finished
	whip.get_node("Audio").play()
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, "rotation_degrees", 360, 0.8)
	for dir in all_dir:
		ray.target_position = dir * (level_manager.tile_size * 1.5)
		ray.force_raycast_update()
		var collision = ray.get_collider()
		if collision:
			if collision.is_in_group("AccessPoint"):
				collision.hit_by_player(whip)
			elif collision.has_method("hit_by_player"):
				collision.hit_by_player(whip.strength)
	await tween.finished
	animated_sprite_2d.rotation_degrees = 0
	animated_sprite_2d.animation = "idle"
	animated_sprite_2d.play()
	level_manager.end_turn()

# check for grapple points availablity
func grapple_check(distance):
	moving = true
	for n in possible_moves:
		n.reset()
	for n in possible_moves:
		ray.target_position = n.dir * (level_manager.tile_size * 1.5)
		for i in distance:
			ray.position = n.dir * level_manager.tile_size * i
			ray.force_raycast_update()
			var collision = ray.get_collider()
			if collision:
				if i == 0:
					break
				n.position = n.dir * level_manager.tile_size * (i + 1)
				await n.check_collision(collision)
				if n.possible:
					n.possible = false
					if i == distance - 1:
						await n.reset()
					continue
				if n.available_action == null:
					n.available_action = waiting_for_action
				break
			if i == distance - 1:
				await n.reset()
				n.possible = false
	moving = false

# executes grapple towards chosen direction
# deals with player animation and hitting destination (if hittable)
func grapple_hit(dir):
	moving = true
	for n in possible_moves:
		n.hide()
	var grapple = []
	var tip = grapple_tip.instantiate()
	var destination = dir.position / level_manager.tile_size
	if destination.y > 0:
		tip.global_position = Vector2(global_position.x - 0.5, global_position.y + 16)
		tip.rotation_degrees = 90
		animated_sprite_2d.animation = "grapple_down"
		await animated_sprite_2d.animation_finished
		get_parent().add_child(tip)
		for i in (destination.y - 1) * 8:
			await get_tree().create_timer(0.005).timeout
			tip.position.y += 4
			var section = grapple_section.instantiate()
			grapple.append(section)
			get_parent().add_child(section)
			section.rotation_degrees = 90
			section.position = Vector2(position.x - 0.5, position.y + 16 + 4 * i)
		destination.y -= 1
	elif destination.y < 0:
		tip.global_position = Vector2(global_position.x - 0.5, global_position.y - 16)
		tip.rotation_degrees = 270
		animated_sprite_2d.animation = "grapple_up"
		await animated_sprite_2d.animation_finished
		get_parent().add_child(tip)
		for i in (-destination.y - 1) * 8:
			await get_tree().create_timer(0.005).timeout
			tip.position.y -= 4
			var section = grapple_section.instantiate()
			grapple.append(section)
			get_parent().add_child(section)
			section.rotation_degrees = 90
			section.position = Vector2(position.x - 0.5, position.y - 16 - 4 * i)
		destination.y += 1 
	elif destination.x > 0:
		tip.global_position = Vector2(global_position.x + 16, global_position.y - 2.5)
		animated_sprite_2d.animation = "grapple_side"
		await animated_sprite_2d.animation_finished
		get_parent().add_child(tip)
		for i in (destination.x - 1) * 8:
			await get_tree().create_timer(0.005).timeout
			tip.position.x += 4
			var section = grapple_section.instantiate()
			grapple.append(section)
			get_parent().add_child(section)
			section.position = Vector2(position.x + 16 + 4 * i, position.y - 2.5)
		destination.x -= 1
	elif destination.x < 0:
		tip.global_position = Vector2(global_position.x - 16, global_position.y - 2.5)
		tip.rotation_degrees = 180
		animated_sprite_2d.animation = "grapple_side"
		await animated_sprite_2d.animation_finished
		get_parent().add_child(tip)
		for i in (-destination.x - 1) * 8:
			await get_tree().create_timer(0.005).timeout
			tip.position.x -= 4
			var section = grapple_section.instantiate()
			grapple.append(section)
			get_parent().add_child(section)
			section.position = Vector2(position.x - 16 - 4 * i, position.y - 2.5)
		destination.x += 1
	if "tile_type" in dir.available_action:
		if dir.available_action.tile_type == "mobile":
			if !dir.available_action.moved:
				grapple_mobile(destination, dir.available_action, grapple, tip)
				if destination.x > 0:
					destination.x -= destination.x / destination.x
				if destination.y > 0:
					destination.y -= destination.y / destination.y
		else:
			dir.available_action.hit_by_player(strength)
	var tween = create_tween().tween_property(self, "position",
			position + destination * level_manager.tile_size,
			1.5/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
	remove_grapple(grapple, tip, destination)
	await tween.finished
	animated_sprite_2d.play("idle")

func grapple_mobile(destination, barrier, grapple, tip):
	var des = destination
	if des.x > 0:
		des.x = des.x / des.x
	if des.y > 0:
		des.y = des.y / des.y
	barrier._on_area_entered(-des * level_manager.tile_size)
	for n in 8:
		await get_tree().create_timer(0.01).timeout
		var section = grapple.pop_back()
		if tip != null:
			tip.position = section.position
		if section != null:
			section.queue_free()

func remove_grapple(grapple, tip, destination):
	while !grapple.is_empty():
		await get_tree().create_timer(0.005).timeout
		if destination != Vector2.ZERO:
			var section = grapple.pop_front()
			if section != null:
				section.queue_free()
	tip.queue_free()

func activate_shield():
	var shield = load("res://Scenes/Prefabs/shield.tscn").instantiate()
	animated_sprite_2d.add_child(shield)
	create_tween().tween_property(shield, "scale",
			Vector2.ONE,
			0.5).set_trans(Tween.TRANS_SINE)

func deactivate_shield():
	animated_sprite_2d.get_child(0).queue_free()

func get_hit():
	var temp_move = moving
	moving = true
	animated_sprite_2d.animation = "get_hit"
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.animation = "idle"
	animated_sprite_2d.play()
	moving = temp_move

func enter_level_animation():
	moving = true
	position = get_tree().get_first_node_in_group("StartTile").position.snapped(Vector2.ONE * level_manager.tile_size)
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.animation = "idle"
	animated_sprite_2d.play()

func death_animation():
	await get_tree().create_timer(0.3).timeout
	animated_sprite_2d.animation = "death"
	animated_sprite_2d.play()
	$PossibleMoves.hide()
	if animated_sprite_2d.get_child_count() > 0:
		deactivate_shield()
