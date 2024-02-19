extends "res://Scripts/Environment/basic_particle.gd"

var deviation_countdown = 0.0

func _ready():
	super._ready()
	speed *= randf_range(1.5, 2.5)

func _process(delta):
	deviation_countdown -= delta
	if deviation_countdown < 0:
		direction.y = -direction.y
		deviation_countdown = randf_range(1.0, 2.0)
	super._process(delta)
