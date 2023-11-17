extends Area2D

var unlocked = false
var opened = false
var tile_type = "door"
var key_lights = []
var light_prefab = preload("res://Scenes/Prefabs/door_light.tscn")

# set up key(s) needed to open door from inspector
@export_category("Setup")
@export var keys_needed : int
@export_enum("blue", "pink", "yellow") var key_type : String

@onready var level_manager = $"../../LevelManager"
@onready var animated_sprite_2d = $"AnimatedSprite2D"

# initial setup for lights with choosen key type
func _ready():
	if keys_needed == 0:
		animated_sprite_2d.frame = 1
		unlocked = true
		return
	var light_position = 0
	for n in keys_needed:
		var light = light_prefab.instantiate()
		light.animation = key_type
		if n % 2 == 0:
			light.position = Vector2(0, -light_position)
		else:
			light_position += 5
			light.position = Vector2(0, light_position)
		add_child(light)
		key_lights += [light]

# called when a key is picked up or used update door status
func update_door():
	if opened:
		return
	var key_count = level_manager.keys.count(key_type)
	for n in key_lights.size():
		if n < key_count:
			key_lights[n].frame = 1
		else:
			key_lights[n].frame = 0
	if key_count == keys_needed:
		animated_sprite_2d.frame = 1
		unlocked = true
	else:
		animated_sprite_2d.frame = 0
		unlocked = false

# called by player with the right key(s)
# makes the tile available for path finding, removes the key(s) used and opens the door
func open_door():
	opened = true
	level_manager.astar_grid.set_point_solid(Vector2i(position) / level_manager.tile_size)
	for n in keys_needed:
		key_lights[n].queue_free()
		level_manager.keys.erase(key_type)
		level_manager.set_keys(level_manager.keys)
	animated_sprite_2d.play("opening")
