extends "res://Scripts/Environment/virtual_level_background.gd"

var shine_count = 0.0
var twinkle_count = 0.0
var framed_checker

@onready var twinkle_prefab = preload("res://Scenes/Prefabs/twinkle.tscn")

func _ready():
	super._ready()
	framed_checker = get_tree().get_first_node_in_group("FramedChecker")

func _process(delta):
	super._process(delta)
	shine_count -= delta
	twinkle_count -= delta
	if shine_count < 0:
		shine()
		shine_count = randf_range(0.1, 1.0)
	if twinkle_count < 0:
		twinkle()
		twinkle_count = randf_range(0.1, 1.0)

func shine():
	if get_tree().get_nodes_in_group("FloorTiles").size() < 2:
		return
	var floor_tile = get_tree().get_nodes_in_group("FloorTiles")[randi_range(0, get_tree().get_nodes_in_group("FloorTiles").size()) - 1]
	while !framed_checker.check(floor_tile.global_position):
		floor_tile = get_tree().get_nodes_in_group("FloorTiles")[randi_range(0, get_tree().get_nodes_in_group("FloorTiles").size()) - 1]
	floor_tile.play()

func twinkle():
	var wall_tile = get_tree().get_nodes_in_group("WallTiles")[randi_range(0, get_tree().get_nodes_in_group("WallTiles").size()) - 1]
	while !framed_checker.check(wall_tile.global_position):
		wall_tile = get_tree().get_nodes_in_group("WallTiles")[randi_range(0, get_tree().get_nodes_in_group("WallTiles").size()) - 1]
	var twink = twinkle_prefab.instantiate()
	add_child(twink)
	twink.global_position = wall_tile.global_position + Vector2(randf_range(-14, 14), randf_range(-14, 14))
	twink.play()
	await twink.animation_finished
	twink.queue_free()
