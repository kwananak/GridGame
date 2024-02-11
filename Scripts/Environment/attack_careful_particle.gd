extends "res://Scripts/Environment/careful_particle.gd"

var player
var seeking = false

func _ready():
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	super._ready()

func deviator():
	seeking = true
	while true:
		await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
		direction = position.move_toward(player.position, 1.0) - position
