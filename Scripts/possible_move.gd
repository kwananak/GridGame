extends Node2D

var possible = false : set = set_possible
var available_action = null : set = set_available_action
var player

@export var dir : Vector2

func _ready():
	player = get_tree().get_first_node_in_group("Player")

# checks collision and adjusts vars accordingly
func check_collision(collision):
	if "tile_type" in collision:
		match collision.tile_type:
			"door":
				if collision.unlocked:
					possible = true
					return
			"hardened":
				if !player.teleport:
					available_action = collision
					return
			"cannon", "enemy":
				if !player.teleport && !collision.is_destroyed:
					available_action = collision
					return
	available_action = null

func reset():
	hide()
	available_action = null
	possible = false
	position = Vector2.ZERO

func set_possible(value):
	possible = value
	if value == true:
		$AnimatedSprite2D.animation = "move"
		show()

func set_available_action(value):
	available_action = value
	if available_action == null:
		hide()
		return
	$AnimatedSprite2D.animation = "hit"
	show()