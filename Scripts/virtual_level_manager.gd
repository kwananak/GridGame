extends "res://Scripts/level_manager.gd"

var turn = 0 : set = end_turn
var freeze = 0 : set = set_freeze
var is_immune_to_bullets = false
var invincible = false
var initial_health = 1
var lives = 1 : set = set_lives
var remaining_actions = 1 : set = set_remaining_actions
var floating = false
var programs = []

@export var firewall_speed = 1 : set = set_firewall_speed
@export var firewall_step = 0.5

func _ready():
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	health = initial_health
	set_lives(lives)
	set_remaining_actions(remaining_actions)
	super._ready()

# calls subscribed nodes when player makes a move
func end_turn(value):
	if freeze > 0 :
		freeze -= 1
		return
	turn = value
	for node in get_tree().get_nodes_in_group("EndTurn"):
		# get_tree().create_timer(end_turn_speed).timeout
		await node.turn_call()
	player.move_check(player.step)

# called when freeze is activated
# shows remaining number of freezed turns, if any
func set_freeze(value):
	freeze = value
	var freeze_ui = ui.get_node("FreezeUI")
	if freeze > 0:
		freeze_ui.text = "freeze = " + str(freeze)
		freeze_ui.visible = true
	else:
		freeze_ui.visible = false

# called when health is changed
# updates onscreen health UI and calls game over if at 0
func set_health(value):
	health = value
	var health_ui = ui.get_node("HealthUI")
	health_ui.text = "health = " + str(health)
	health_ui.visible = true
	if health <= 0:
		lives -= 1
		reset_health()

func reset_health():
	health = initial_health

# called when lives is changed
# updates onscreen lives UI and calls game over if at 0
func set_lives(value):
	lives = value
	var lives_ui = ui.get_node("LivesUI")
	lives_ui.text = "lives = " + str(lives)
	lives_ui.visible = true
	if lives <= 0:
		call_game_over()

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
	for p in programs:
		progress_manager.add_to_programs(p[0], p[1])
	super.on_end_tile_entered()
