extends Area2D

@export var wait_time_min = 5.0
@export var wait_time_max = 8.0
@onready var sprite = $Sprite

func _ready():
	animation_loop()

func animation_loop():
	while true:
		await get_tree().create_timer(randf_range(wait_time_min, wait_time_max)).timeout
		$Sprite.play()
