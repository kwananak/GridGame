extends "res://Scripts/Environment/careful_particle.gd"

var original_x

var reverse_countdown = 0.0

func _ready():
	super._ready()
	speed *= 1.5
	original_x = direction.x

func _process(delta):
	reverse_countdown -= delta
	if reverse_countdown < 0:
		reverse_countdown = randf_range(1.0, 2.0)
		zigzagger()

func zigzagger():
		if randf_range(0.0, 10.0) < 8.0:
			direction.x = original_x
		else:
			direction.x = -original_x
