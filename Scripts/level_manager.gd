extends Node2D

var turn = 0 : set = end_turn
var keys = [] : set = set_keys
var paused = false : set = set_pause
var game_over = false
var astar_grid = AStarGrid2D.new()
var freeze = 0 : set = set_freeze
var health = 1 : set = set_health
var terminal_is_opened = false : set = set_terminal_is_opened
var player

# setup level specs from inspector. Firewall speed: 1 will move every turn, 2 every 2 turn, etc.
@export var level_height = 640
@export var level_length = 1800
@export var firewall_speed = 1
@export var firewall_step = 0.5
@export var level_number = 0
@export var tile_size = 32
@export var animation_speed = 6
@export var end_turn_speed = 0.05

@onready var button = $"../UI/Button"
@onready var camera = $"../../Camera2D"
@onready var ui = $"../UI"

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	initialize_grid()
	set_health(health)

func _process(_delta):
	if paused:
		return
	process_camera()

# sets up a* grid for path finding in level
func initialize_grid():
	astar_grid.region = Rect2i(Vector2i(0, 0), Vector2i(level_length, level_height) / tile_size)
	astar_grid.cell_size = Vector2i.ONE * tile_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.update()
	for n in get_tree().get_nodes_in_group("AStarGridSolid"):
		astar_grid.set_point_solid(Vector2i(n.position) / tile_size, true)

# called by player input func to pause the game
func press_pause():
	if terminal_is_opened:
		return
	paused = !paused

# update paused value and shows or hide pause "menu" accordingly
func set_pause(value):
	paused = value
	if paused:
		button.text = "Quit"
		button.visible = true
	else:
		button.visible = false

# sets value of terminal_is_opened bool and syncs the pause value to it
func set_terminal_is_opened(value):
	terminal_is_opened = value
	paused = value

# called when keys are acquired or used
# shows inventory of key in UI, if any
func set_keys(value):
	keys = value
	var doors = get_tree().get_nodes_in_group("Doors")
	if !doors.is_empty():
		for door in doors:
			door.update_door()
	if keys.is_empty():
		ui.get_node("KeysUI").visible = false
	else:
		var blue_keys = ""
		if keys.count("blue") > 0:
			blue_keys += "blue Keys: " +str(keys.count("blue"))
		var pink_keys = ""
		if keys.count("pink") > 0:
			pink_keys += "Pink Keys: " +str(keys.count("pink"))
		var yellow_keys = ""
		if keys.count("yellow") > 0:
			yellow_keys += "Yellow Keys: " +str(keys.count("yellow"))
		var keys_ui = ui.get_node("KeysUI")
		keys_ui.text = blue_keys + "\n" + pink_keys + "\n" + yellow_keys
		keys_ui.visible = true

# called when freeze is picked up
# shows remaining number of freezed turns, if any
func set_freeze(value):
	freeze = value
	if freeze > 0:
		var freeze_ui = ui.get_node("FreezeUI")
		freeze_ui.text = "freeze = " + str(freeze)
		freeze_ui.visible = true
	else:
		ui.get_node("FreezeUI").visible = false

# called when health is changed
# updates onscreen health UI and calls game over if at 0
func set_health(value):
	health = value
	if health > 0:
		var health_ui = ui.get_node("HealthUI")
		health_ui.text = "health = " + str(health)
		health_ui.visible = true
	else:
		call_game_over()
		
# tracks camera to player on wider levels and matches UI position to it
func process_camera():
	if player.position.x > 288 and player.position.x < level_length - 288:
		camera.position.x = player.position.x
	if player.position.y > 160 and player.position.y < level_height - 160:
		camera.position.y = player.position.y
	ui.position = camera.position

# called by the button to quit the level
func _on_button_pressed():
	$/root/Main.call_menu(level_number)

# listens for spacebar to quit the game when game is over
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE and game_over:
			_on_button_pressed()

# called by end tile when the player reaches it
func on_end_tile_entered():
	game_over = true
	button.text = "Game Won!!"
	button.visible = true

# called by game ending entities when colliding with player
func call_game_over():
	game_over = true
	button.text = "Game Lost!"
	button.visible = true

# calls subscribed nodes when player makes a move
func end_turn(value):
	if freeze > 0 :
		freeze -= 1
		return
	turn = value
	for node in get_tree().get_nodes_in_group("EndTurn"):
		await get_tree().create_timer(end_turn_speed).timeout
		node.turn_call()
