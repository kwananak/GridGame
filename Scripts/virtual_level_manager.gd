extends "res://Scripts/level_manager.gd"

var turn = 0
var freeze = 0
var is_immune_to_bullets = false
var invincible = false
var initial_health = 1
var lives = 0 : set = set_lives
var remaining_actions = 1 : set = set_remaining_actions
var floating = false
var programs = []
var vision = false
var dialogue = false
var shield = 0 : set = set_shield

@export var firewall_speed = 1 : set = set_firewall_speed
@export var firewall_step = 0.5

func _ready():
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	health = initial_health
	set_lives(lives + 1)
	set_remaining_actions(remaining_actions)
	super._ready()

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
	for node in get_tree().get_nodes_in_group("EndTurn"):
		# get_tree().create_timer(end_turn_speed).timeout
		await node.turn_call()
	await get_tree().create_timer(0.02).timeout
	player.move_check(player.step)

func set_shield(value):
	if shield == 0 && value > 0:
		player.activate_shield()
	if shield > 0 && value <= 0:
		player.deactivate_shield()
	shield = value

# called when health is changed
# updates onscreen health UI and calls game over if at 0
func set_health(value):
	if value < health && shield > 0:
		shield -= 1
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
			var heart = ui.get_node("HealthUI/Heart" + str(health - 1 - i))
			heart.hide()
			await get_tree().create_timer(0.3).timeout
	health = value
	if health <= 0:
		lives -= 1

func heart_spawn_anim(heart):
	heart.animation = "new"
	heart.play()
	await heart.animation_finished
	heart.animation = "default"
	heart.play()

func reset_health():
	health = initial_health

# called when lives is changed
# updates onscreen lives UI and calls game over if at 0
func set_lives(value):
	if value > lives:
		var lives_diff = value - lives
		for i in lives_diff:
			var life = ui.get_node("LivesUI/Life" + str(lives + i))
			life.show()
			life_spawn_anim(life)
	if value < lives:
		var lives_diff = lives - value
		for i in lives_diff:
			var life = ui.get_node("LivesUI/Life" + str(lives - 1 - i))
			life.hide()
		if value > 0:
			reset_health()
	lives = value
	if lives <= 0:
		call_game_over()

func life_spawn_anim(life):
	life.animation = "new"
	life.play()
	await life.animation_finished
	life.animation = "default"
	life.play()
	

func set_remaining_actions(value):
	remaining_actions = value
	var actions_ui = ui.get_node("ProgramBar/Labels/Brain")
	actions_ui.text = str(remaining_actions)

func set_firewall_speed(value):
	if value < 0:
		firewall_speed = 0
	else:
		firewall_speed = value

func on_end_tile_entered():
	var progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	for a in programs:
		progress_manager.add_to_programs(a[0], a[1])
	super.on_end_tile_entered()
