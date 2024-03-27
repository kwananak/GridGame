extends Control

var paused = false
var loaded_prefab
var level_manager
var upper_range = 1.5
var next_spawn_countdown = 0.0
var basic_particle_prefab
var careful_particle_prefab
var danger_particle_prefab

@onready var active_node = $Careful

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	if level_manager != null:
		level_manager.pause_trigger.connect(set_pause)
		level_manager.game_over_trigger.connect(set_pause)
		upper_range = 0.3
		level_manager.doomwall_state_changed.connect(state_changed)
	var number = get_parent().name.substr(5, 1)
	if not int(number):
		number = "1"
	basic_particle_prefab = load("res://Scenes/Tiles/VirtualEnvironment" + number + "00/" + number + "00_basic_particle.tscn")
	careful_particle_prefab = load("res://Scenes/Tiles/VirtualEnvironment" + number + "00/" + number + "00_careful_particle.tscn")
	danger_particle_prefab = load("res://Scenes/Tiles/VirtualEnvironment" + number + "00/" + number + "00_danger_particle.tscn")
	loaded_prefab = basic_particle_prefab

func _process(delta):
	if paused:
		return
	next_spawn_countdown -= delta
	if next_spawn_countdown < 0:
		add_child(loaded_prefab.instantiate())
		next_spawn_countdown = randf_range(0.1, upper_range)

func set_pause(value):
	paused = value

func state_changed(value):
	match value:
		"careful":
			$Careful.show()
			loaded_prefab = careful_particle_prefab
		"danger":
			$Careful.hide()
			$Danger.show()
			loaded_prefab = danger_particle_prefab
			upper_range = 0.2
	for n in get_children():
		if not n is ColorRect:
			var substitute = loaded_prefab.instantiate()
			add_child(substitute)
			substitute.rotation = n.rotation
			substitute.direction = n.direction
			substitute.position = n.position
			n.queue_free()
