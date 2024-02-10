extends Area2D

@export var wait_time_min = 5.0
@export var wait_time_max = 12.0
@onready var sprite = $Sprite

var animating = false

func _ready():
	animation_loop()

func animation_loop():
	if animating:
		return
	animating = true
	await get_tree().create_timer(randf_range(0.5, 8.0)).timeout
	$Sprite.play()
	while true:
		if !is_inside_tree():
			break
		await get_tree().create_timer(randf_range(wait_time_min, wait_time_max)).timeout
		$Sprite.play()
	animating = false

func _on_tree_entered():
	animation_loop()
