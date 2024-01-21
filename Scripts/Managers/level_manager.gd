extends Node2D

var keys = [] : set = set_keys
var paused = false : set = set_pause
var game_over = false
var astar_grid = AStarGrid2D.new()
var health = 0 : set = set_health
var player
var player_sprite
var view_margin

# setup level specs from inspector. Firewall speed: 1 will move every turn, 2 every 2 turn, etc.
@export var level_height = 32
@export var level_length = 128
@export var level_number = 0
@export var tile_size = 32
@export var animation_speed = 6
@export var end_turn_speed = 0.1
@export var camera_speed = 200

@onready var button = $"../UI/Button"
@onready var camera = $"../../Camera2D"
@onready var ui = $"../UI"
var tile_map

func _ready():
	tile_map = get_tree().get_first_node_in_group("TileMap")
	initialize_grid()
	view_margin = get_viewport_rect().size / 4
	player_sprite = player.get_node("AnimatedSprite2D")

func _process(delta):
	process_camera(delta)

# sets up a* grid for path finding in level
func initialize_grid():
	astar_grid.region = Rect2i(Vector2i(0, 0), Vector2i(level_length, level_height))
	astar_grid.cell_size = Vector2i.ONE * tile_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	astar_grid.update()
	for n in get_tree().get_nodes_in_group("AStarGridSolid"):
		astar_grid.set_point_solid(Vector2i(n.position) / tile_size, true)

# called by player input func to pause the game
func press_pause():
	paused = !paused

# update paused value and shows or hide pause "menu" accordingly
func set_pause(value):
	paused = value
	if paused:
		button.text = "Quit"
		button.visible = true
		button.grab_focus()
	else:
		button.visible = false

# called when keys are acquired or used
# shows inventory of key in UI, if any
func set_keys(value):
	keys = value
	var keys_ui = ui.get_node("KeysUI")
	var doors = get_tree().get_nodes_in_group("Doors")
	if !doors.is_empty():
		for door in doors:
			door.update_door()
	if keys.is_empty():
		keys_ui.visible = false
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
		keys_ui.text = blue_keys + "\n" + pink_keys + "\n" + yellow_keys
		keys_ui.visible = true

# called when health is changed
# updates onscreen health UI and calls game over if at 0
func set_health(value):
	health = value
	var health_ui = ui.get_node("HealthUI")
	health_ui.text = "health = " + str(health)
	health_ui.visible = true
	if health <= 0:
		call_game_over()

# tracks camera to player on wider levels and matches UI position to it
func process_camera(delta):
	if player_sprite.global_position.x < view_margin.x:
		camera.position.x = view_margin.x
	elif player_sprite.global_position.x > level_length * tile_size - view_margin.x:
		camera.position.x = level_length * tile_size - view_margin.x
	else:
		camera.position = camera.position.move_toward(Vector2(player_sprite.global_position.x, camera.position.y), delta * camera_speed)
	if player_sprite.global_position.y < view_margin.y:
		camera.position.y = view_margin.y
	elif player_sprite.global_position.y > level_height * tile_size - view_margin.y:
		camera.position.y = level_height * tile_size - view_margin.y
	else:
		camera.position = camera.position.move_toward(Vector2(camera.position.x, player_sprite.global_position.y), delta * camera_speed)
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
