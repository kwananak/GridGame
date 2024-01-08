extends Area2D

var info

var tile_type = "chip"

func _ready():
	$Sprite2D.frame = randi_range(0, 3)

func pick_up(_area):
	pass
