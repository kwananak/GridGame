extends Area2D

var moused = false

var player

func _ready():
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	get_tree().get_first_node_in_group("Settings").joypad_config_signal.connect(update_label)
	update_label(false)

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

func update_label(_joypad):
	if is_inside_tree():
		$Label.text = get_tree().get_first_node_in_group("SkipSettingButton").button.text

func _on_tree_entered():
	update_label(false)
