extends "res://Scripts/player.gd"

var strength = 1
var step = 1
var possible_moves
var teleport = false

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	possible_moves = $PossibleMoves.get_children()
	await enter_level_animation()
	move_check(step)

func _unhandled_input(event):
	if moving || level_manager.game_over:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			if inputs[dir] == inputs.pause:
				level_manager.press_pause()
				return
			if level_manager.paused:
				return
			match dir:
				"skip_turn":
					skip_turn()
					return
				"left":
					animated_sprite_2d.flip_h = true
				"right":
					animated_sprite_2d.flip_h = false
			var dir_node = get_node("PossibleMoves/" + dir)
			if dir_node.available_action != null:
				act(dir_node)
				return
			if dir_node.possible:
				move(dir_node.global_position)

# self explanatory
func skip_turn():
	moving = true
	await level_manager.end_turn(level_manager.turn + 1)

# triggers action on selected direction
func act(dir):
	moving = true
	for n in possible_moves:
		n.reset()
	dir.available_action.hit_by_player(strength)
	await level_manager.end_turn(level_manager.turn + 1)

# grid based character movement to available checked locations
func move(pos):
	moving = true
	for n in possible_moves:
		n.reset()
	if teleport:
		hide()
		await get_tree().create_timer(0.1).timeout
		var tween = create_tween()
		tween.tween_property(self, "position",
				pos,
				1.5/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
		animated_sprite_2d.play("move")
		await tween.finished
		await get_tree().create_timer(0.1).timeout
		show()
	else:
		var tween = create_tween()
		tween.tween_property(self, "position",
				pos,
				1.5/level_manager.animation_speed).set_trans(Tween.TRANS_SINE)
		animated_sprite_2d.play("move")
		await tween.finished
		animated_sprite_2d.play("idle")
	if waiting_for_action != null:
		waiting_for_action.confirm()
		waiting_for_action = null
	level_manager.end_turn(level_manager.turn + 1)

# check for available location for player movement or action
func move_check(distance):
	moving = true
	if level_manager.game_over:
		return
	for n in possible_moves:
		n.reset()
	for n in possible_moves:
		if teleport:
			n.position = n.dir * (level_manager.tile_size * distance)
			await get_tree().create_timer(0.017).timeout
		else:
			for i in distance:
				n.position = n.dir * (level_manager.tile_size * (i + 1))
				await get_tree().create_timer(0.017).timeout
				if !n.possible:
					if i > 0:
						n.position = n.dir * (level_manager.tile_size * i)
						await get_tree().create_timer(0.017).timeout
						break
					elif i == 0:
						break
		if n.possible:
			n.get_node("Move").show()
		if n.available_action != null:
			n.get_node("Action").show()
	moving = false
