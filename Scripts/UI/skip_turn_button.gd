extends Area2D

var moused = false

var player

func _ready():
	player = get_tree().get_first_node_in_group("VirtualPlayer")

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == 1 && moused:
			player.skip_turn()

func _on_mouse_entered():
	moused = true

func _on_mouse_exited():
	moused = false

func show_skip():
	$AnimatedSprite2D.frame = 1
	await get_tree().create_timer(0.2).timeout
	$AnimatedSprite2D.frame = 0
