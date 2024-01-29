extends "res://Scripts/Managers/level_manager.gd"

var turn = 0
var freeze = 0
var is_immune_to_bullets = false
var invincible = false
var initial_health = 1
var remaining_actions = 1 : set = set_remaining_actions
var floating = false
var programs = []
var vision = false
var dialogue = false
var shields = 0 : set = set_shield
var doomwall

@export var green_doomwall_step = 0.0
@export var yellow_doomwall_step = 1.0
@export var red_doomwall_step = 2.0

func _ready():
	doomwall = get_tree().get_first_node_in_group("DoomWall")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	health = initial_health
	set_remaining_actions(remaining_actions)
	super._ready()

func _process(delta):
	if dialogue:
		ui.position = camera.position
		return
	super._process(delta)

# update paused value and shows or hide pause "menu" accordingly
func set_pause(value):
	if dialogue:
		paused = true
		return
	paused = value
	if paused:
		button.text = "Quit"
		button.visible = true
		button.grab_focus()
	else:
		button.visible = false

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
	for node in get_tree().get_nodes_in_group("EndTurn"):
		# get_tree().create_timer(end_turn_speed).timeout
		await node.turn_call()
	await get_tree().create_timer(0.02).timeout
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
			var heart = ui.get_node("HealthUI/Heart" + str(health - i))
			heart.hide()
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
	var actions_ui = ui.get_node("ProgramBar/Labels/Brain")
	actions_ui.text = str(remaining_actions)

func on_success(level):
	doomwall.fade_out()
	var progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	$/root/Main.add_to_levels(level)
	for a in programs:
		progress_manager.add_to_programs(a[0], a[1])
	super.on_end_tile_entered()

func call_game_over():
	var audio = get_parent().get_node("AudioStreamPlayer")
	create_tween().tween_property(audio, "volume_db", -80, 1)
	player.death_animation()
	super.call_game_over()
