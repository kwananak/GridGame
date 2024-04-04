extends "res://Scripts/Managers/level_manager.gd"

var turn = 0
var time_elapsed = 0.0
var barriers_down = [0, 0, 0]
var freeze = 0
var is_immune_to_bullets = false
var invincible = false
var initial_health = 1
var remaining_actions = 0 : set = set_remaining_actions
var floating = false
var programs = []
var vision = false
var dialogue = false : set = set_dialogue
var shields = 0 : set = set_shield
var doomwall
var doomwall_state = "default" : set = set_doomwall_state
var pause_menu
var progress_manager

signal barrier_down
signal doomwall_state_changed

@export var skip_dialogues = false
@export var green_doomwall_step = 0.0
@export var yellow_doomwall_step = 1.0
@export var red_doomwall_step = 2.0
@export var attack_particles = false

@onready var summary_prefab = preload("res://Scenes/UI/level_summary.tscn")
@onready var fail_prefab = preload("res://Scenes/UI/level_fail.tscn")
@onready var pause_prefab = preload("res://Scenes/UI/virtual_pause.tscn")

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	doomwall = get_tree().get_first_node_in_group("DoomWall")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	health = initial_health
	var action_points = 0
	for n in progress_manager.amplifiers.get_children():
		action_points += n.strength
	set_remaining_actions(action_points)
	if str(level_number) in progress_manager.completed_levels:
		skip_dialogues = true
	super._ready()

func _process(delta):
	time_elapsed += delta
	if dialogue:
		ui.position = camera.position
		return
	super._process(delta)

func set_doomwall_state(value):
	doomwall_state = value
	doomwall_state_changed.emit(value)

func set_dialogue(value):
	if !value:
		await create_tween().tween_property(camera, "position", out_of_bounds_check(player_sprite.global_position), 0.2).finished
	dialogue = value

# update paused value and shows or hide pause "menu" accordingly
func set_pause(value):
	if value:
		spawn_pause_menu()
	else:
		despawn_pause_menu()
		pause_menu = null
		if dialogue:
			dialogue.button.grab_focus()
	paused = value
	pause_trigger.emit(paused)

func spawn_pause_menu():
	pause_menu = pause_prefab.instantiate()
	ui.add_child(pause_menu)
	var new_position = Vector2(240, 0)
	if camera.zoom.x > 2:
		pause_menu.scale /= 1.2
		new_position.x += 100
	pause_menu.global_position = Vector2(camera.global_position.x + get_viewport_rect().size.x / 4 + 100, camera.global_position.y)
	create_tween().tween_property(pause_menu, "position", pause_menu.position - new_position, 0.3)

func despawn_pause_menu():
	var p_m = pause_menu
	await create_tween().tween_property(p_m, "position", pause_menu.position + Vector2(240, 0), 0.3).finished
	p_m.queue_free()

# calls subscribed nodes when player makes a move
func end_turn():
	if game_over:
		return
	if freeze > 0 :
		freeze -= 1
		var freezer = get_tree().get_first_node_in_group("Freeze")
		if freezer:
			freezer.turn_call()
		else:
			if freeze == 0:
				ui.get_node("FreezeUI").text = ""
			else:
				ui.get_node("FreezeUI").text = "freeze: " + str(freeze)
		player.move_check(player.step)
		return
	turn += 1
	await doomwall.turn_call()
	for n in get_tree().get_nodes_in_group("EndTurn"):
		await n.turn_call()
	await get_tree().create_timer(0.03).timeout
	for n in get_tree().get_nodes_in_group("LatterEndTurn"):
		await n.turn_call()
	player.move_check(player.step)

func set_shield(value):
	if value > shields:
		var shields_diff = value - shields
		for i in shields_diff:
			var shield = ui.get_node("ShieldsUI/Shield" + str(shields + i))
			shield.show()
			shield_spawn_anim(shield)
	if value < shields:
		var diamond_armor = get_tree().get_first_node_in_group("DiamondArmor")
		if diamond_armor:
			if diamond_armor.used < diamond_armor.strength:
				diamond_armor.used += 1
		var shields_diff = shields - value
		for i in shields_diff:
			var shield = ui.get_node("ShieldsUI/Shield" + str(shields - 1 - i))
			shield.hide()
	if shields == 0 && value > 0:
		player.activate_shield()
	if shields > 0 && value <= 0:
		player.deactivate_shield()
	shields = value

# called when health is changed
# updates onscreen health UI and calls game over if at 0
func set_health(value):
	if game_over:
		return
	if value < health && shields > 0:
		shields -= 1
		return
	if value > health:
		var health_diff = value - health
		for i in health_diff:
			var heart = ui.get_node("HealthUI/Heart" + str(health + i))
			heart.show()
			heart_spawn_anim(heart)
	if value < health:
		var health_diff = health - value
		for i in health_diff:
			await player.get_hit()
			#var heart = ui.get_node("HealthUI/Heart" + str(health - i))
			#heart.hide()
	health = value
	if health <= 0:
		call_game_over()

func heart_spawn_anim(heart):
	heart.animation = "new"
	heart.play()
	await heart.animation_finished
	heart.animation = "default"
	heart.play()

func reset_health():
	health = initial_health

func shield_spawn_anim(shield):
	shield.animation = "new"
	shield.play()
	await shield.animation_finished
	shield.animation = "default"
	shield.play()

func set_remaining_actions(value):
	remaining_actions = value
	var actions_ui = ui.get_node("ProgramBar/Labels/Actions")
	if value < 1:
		actions_ui.hide()
		return
	else:
		actions_ui.text = str(remaining_actions)
		if value == 1:
			actions_ui.get_node("Label").text = "ACTION"
		else:
			actions_ui.get_node("Label").text = "ACTIONS"
		actions_ui.show()

func on_success(level_unlocked):
	game_over = true
	game_over_trigger.emit(true)
	var audio = get_parent().get_node("AudioStreamPlayer")
	get_tree().get_first_node_in_group("BackgroundColors").get_node("Careful").visible = false
	get_tree().get_first_node_in_group("BackgroundColors").get_node("Danger").visible = false
	create_tween().tween_property(audio, "volume_db", -25, 1)
	doomwall.fade_out()
	for a in programs:
		await get_tree().get_first_node_in_group("ProgressManager").add_to_programs(a[0], a[1], level_number)
	$/root/Main.add_to_levels(level_unlocked, level_number)
	await create_tween().tween_property(camera, "global_position", player.global_position + Vector2(128, 0), 0.5).finished
	display_summary()

func call_game_over():
	if game_over:
		return
	game_over = true
	game_over_trigger.emit(true)
	var audio = get_parent().get_node("AudioStreamPlayer")
	create_tween().tween_property(audio, "volume_db", -80, 1)
	player.death_animation()
	display_fail()

func display_summary():
	var summary = summary_prefab.instantiate()
	var body = "[center]Time: " + str(int(time_elapsed)) + " seconds\nTurns: " + str(turn) # + "\nBarriers: " + str(barriers_down)
	for a in programs:
		body += "\n\n[color=green]" + a[0] + " Aquired: " + a[1].name
	summary.get_node("Title").text = $/root/Main.get_level_name(level_number)
	summary.get_node("Body").append_text(body)
	if ui.has_node("LevelSummary"):
		summary = ui.get_node("LevelSummary")
		summary.get_node("Button").grab_focus()
	else:
		ui.add_child(summary)
		summary.global_position = Vector2(camera.position.x + get_viewport_rect().size.x / 4  + 200, camera.position.y)
		create_tween().tween_property(summary, "position", summary.position - Vector2(440, 0), 0.3)
		ui.toggle_ui(true)

func display_fail():
	if pause_menu:
		return
	pause_menu = fail_prefab.instantiate()
	get_parent().add_child(pause_menu)
	pause_menu.position = Vector2(camera.position.x + get_viewport_rect().size.x / 4 + 100, camera.position.y)
	var new_position = Vector2(240, 0)
	if camera.zoom.x > 2:
		pause_menu.scale /= 1.2
		new_position.x += 100
	create_tween().tween_property(pause_menu, "position", pause_menu.position - new_position, 0.3)
	ui.hide()

func back_to_terminal():
	dezoom_camera()
	$/root/Main.back_to_terminal()

func call_menu():
	dezoom_camera()
	$/root/Main.call_menu(level_number)

func _on_tree_entered():
	if camera:
		if game_over:
			camera.zoom *= 1.2
			ui.scale /= 1.2
		camera.position = out_of_bounds_check(player.position)
		await get_tree().create_timer(0.1).timeout
		if pause_menu:
			if pause_menu.name == "VirtualPause":
				pause_menu.resume.grab_focus()
			else:
				pause_menu.retry.grab_focus()

func zoom_camera():
	if camera.zoom.x == 2:
		create_tween().tween_property(camera, "zoom", camera.zoom * 1.2, 1.0)
		create_tween().tween_property(ui, "scale", ui.scale / 1.2, 1.0)

func dezoom_camera():
	$/root/Main.dezoom_camera()
	ui.scale *= 1.2
