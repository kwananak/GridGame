extends "res://Scripts/Environment/careful_particle.gd"

var original_x

func _ready():
	super._ready()
	speed *= 1.5
	original_x = direction.x
	zigzagger()

func zigzagger():
	while true:
		if !is_inside_tree():
			continue
		await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
		var dice = randf_range(0.0, 10.0)
		if dice < 8.0:
			direction.x = original_x
		else:
			direction.x = -original_x
