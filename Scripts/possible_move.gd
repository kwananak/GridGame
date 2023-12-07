extends Area2D

var possible = true
var available_action = null
var player
@export var dir : Vector2

func _ready():
	player = get_tree().get_first_node_in_group("Player")

# checks for collision and adjusts vars accordingly
func _on_area_entered(area):
	if not "tile_type" in area:
		possible = false
		return
	match area.tile_type:
		"door":
			if area.unlocked:
				return
		"hardened":
			if !player.teleport:
				available_action = area
	possible = false

# resets vars when no longer colliding
func _on_area_exited(_area):
	possible = true
	available_action = null

func reset():
	available_action = null
	position = Vector2.ZERO
	$Move.hide()
	$Action.hide()
