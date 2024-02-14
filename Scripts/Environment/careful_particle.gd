extends "res://Scripts/Environment/basic_particle.gd"

func _ready():
	super._ready()
	deviator()
	speed *= randf_range(1.5, 2.5)

func deviator():
	while true:
		if !is_inside_tree():
			continue
		await get_tree().create_timer(randf_range(1.0, 2.0)).timeout
		direction.y = -direction.y
