extends Area2D

var on = false : set = set_on
var start_up = true
@export var door_number : int
@export var lock = true

@onready var start_tile

func _ready():
	start_tile = get_tree().get_first_node_in_group("StartTile")
	await get_tree().create_timer(0.3).timeout
	start_up = false

func _on_area_entered(_area):
	if !on:
		return
	get_tree().get_first_node_in_group("RealPlayer").exit_level(self)
	if start_tile.global_position == global_position:
		start_tile.get_node("AnimatedSprite2D").play("open")
	var l_m = get_tree().get_first_node_in_group("RealLevelManager")
	l_m.real_done = door_number
	l_m.on_end_tile_entered(door_number)

func set_on(value):
	if start_up:
		return
	on = value

func _on_area_exited(_area):
	await get_tree().create_timer(0.2).timeout
	on = true
