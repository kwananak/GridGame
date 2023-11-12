extends Area2D

@export var strength = 3

func set_freeze_strength():
	$"../../../LevelManager".freeze = strength
	queue_free()
