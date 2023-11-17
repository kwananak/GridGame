extends Node2D

var turn = 0: set = end_turn
var keys = []: set = set_keys
var paused = false
var game_over = false
var astar_grid = AStarGrid2D.new()
var freeze = 0: set = set_freeze

# setup level specs from inspector. Firewall speed: 1 will move every turn, 2 every 2 turn, etc.
@export var level_height = 640
@export var level_length = 1800
@export var firewall_speed = 1
@export var firewall_step = 0.5
@export var level_number = 0
@export var tile_size = 32
@export var animation_speed = 6
@export var end_turn_speed = 0.05
@export var end_turn_calls : Array[Node] = []
@export var doors : Array[Node] = []

@onready var button = $"../UI/Button"
@onready var player = $"../Player"
@onready var camera = $"../../Camera2D"
@onready var ui = $"../UI"

func _ready():
	initialize_grid()

func _process(_delta):
	process_camera()

# sets up a* grid for path finding in level
func initialize_grid():
	astar_grid.region = Rect2i(Vector2i(0, 0), Vector2i(level_length, level_height) / tile_size)
	astar_grid.cell_size = Vector2i.ONE * tile_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.update()
	for wall in $"../Environment/Walls".get_children():
		astar_grid.set_point_solid(Vector2i(wall.position) / tile_size, true)

# called by player input func to peuase the game
func pause_game():
	paused = !paused
	if paused:
		button.text = "Quit"
		button.visible = true
	else:
		button.visible = false

# called when keys are acquired or used
# shows inventory of key in UI, if any
func set_keys(value):
	keys = value
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

# tracks camera to player on wider levels and matches UI position to it
func process_camera():
	if player.position.x > 288 and player.position.x < level_length - 288:
		camera.position.x = player.position.x
	if player.position.y > 160 and player.position.y < level_height - 160:
		camera.position.y = player.position.y
	ui.position = camera.position

# called by the button to quit the level
func _on_button_pressed():
	get_node("/root/Main").call_menu(level_number)

# listens for spacebar to restart the game when game is over
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
	for node in end_turn_calls:
		await get_tree().create_timer(end_turn_speed).timeout
		node.turn_call()
