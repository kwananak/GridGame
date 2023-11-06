extends Node

var turn = 0
var game_over = false
var game_won = false

# setup level specs from inspector
@export var firewall_speed = 0
@export var level_number = 0

@onready var button = $"../UI/Button"

# called by the button to restart the game
func _on_button_pressed():
	get_node("/root/Main").call_menu(level_number)

# listens for spacebar to restart the game when game is over
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE and game_over:
			_on_button_pressed()

# called by end tile when the player reaches it
func _on_end_tile_area_entered(_area):
	game_over = true
	game_won = true
	button.text = "Game Won!!"
	button.visible = true

# called by firewall when colliding with player
func call_game_over():
	game_over = true
	button.text = "Game Lost!"
	button.visible = true
