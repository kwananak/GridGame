extends Sprite2D

@export var wait_time = 0.5
@export var fade_speed = 0.5
@export var duration = 5.0
@export var date : int
@export var position_from_center = Vector2(-220, 100)

var fading_in = false
var camera

func _ready():
	modulate.a = 0.0
	if date == 0:
		position_from_center = Vector2(-320, 180)
		date = 4031
	$Label.text += str(date)
	camera = get_tree().get_first_node_in_group("Camera")
	await get_tree().create_timer(wait_time).timeout
	fading_in = true

func _process(delta):
	global_position = camera.global_position + position_from_center
	if fading_in:
		if modulate.a < 1.0:
			modulate.a += delta * fade_speed
		else:
			fading_in = false
	else:
		duration -= delta
		if duration < 0.0:
			if modulate.a <= 0.0:
				queue_free()
			modulate.a -= delta * fade_speed
