extends Area2D

@export var key_type = Color.GREEN
@onready var sprite = $Sprite2D

func _ready():
	match key_type:
		Color.GREEN:
			sprite.texture = load("res://Sprites/GreenKey.png")
		Color.RED:
			sprite.texture = load("res://Sprites/RedKey.png")

func pick_up_key():
	$"../../../LevelManager".keys += [key_type]
	queue_free()
