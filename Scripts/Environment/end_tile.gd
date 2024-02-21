extends Area2D

@export var on = false
@export var door_number : int
@export var lock = true

@onready var start_tile

func _ready():
	start_tile = get_tree().get_first_node_in_group("StartTile")
	if start_tile.global_position == global_position:
		await start_tile.get_node("AnimatedSprite2D").animation_finished
		start_tile.get_node("AnimatedSprite2D").animation = "unlocked"

func _on_area_entered(_area):
	if !on:
		return
	if get_tree().get_first_node_in_group("VirtualLevelManager") != null:
		get_tree().get_first_node_in_group("VirtualLevelManager").on_end_tile_entered()
	else:
		if start_tile.global_position == global_position:
			start_tile.get_node("AnimatedSprite2D").animation = "default"
			start_tile.get_node("AnimatedSprite2D").play_backwards()
		var l_m = get_tree().get_first_node_in_group("RealLevelManager")
		l_m.real_done = door_number
		l_m.on_end_tile_entered(door_number)

func _on_area_exited(_area):
	await get_tree().create_timer(0.1).timeout
	on = true
