extends Control

var paused = false
var loaded_prefab
var level_manager
var upper_range

@onready var active_node = $Careful
@onready var basic_particle_prefab = preload("res://Scenes/Tiles/basic_particle.tscn")
@onready var careful_particle_prefab = preload("res://Scenes/Tiles/careful_particle.tscn")
@onready var danger_particle_prefab = preload("res://Scenes/Tiles/danger_particle.tscn")

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	upper_range = 1.0
	if level_manager != null:
		level_manager.pause_trigger.connect(set_pause)
		level_manager.game_over_trigger.connect(set_pause)
		upper_range = 0.3
	loaded_prefab = basic_particle_prefab
	spawn_particles()

func spawn_particles():
	while true:
		await get_tree().create_timer(randf_range(0.1, upper_range)).timeout
		if !paused:
			add_child(loaded_prefab.instantiate())

func _on_careful_visibility_changed():
	loaded_prefab = careful_particle_prefab

func _on_danger_visibility_changed():
	loaded_prefab = danger_particle_prefab
	upper_range = 0.2

func set_pause(value):
	paused = value
