extends Area2D

func _ready():
	$"AnimatedSprite2D".frame = randi_range(0, 3)
