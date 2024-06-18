extends Area2D

var moused = false

var player
var level_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	level_manager.pause_trigger.connect(show_pause)
	get_tree().get_first_node_in_group("Settings").joypad_config_signal.connect(update_label)
	update_label(false)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == 1 && moused:
			level_manager.press_pause()

func _on_mouse_entered():
	moused = true

func _on_mouse_exited():
	moused = false

func show_pause(paused):
	if paused:
		$AnimatedSprite2D.frame = 1
	else:
		$AnimatedSprite2D.frame = 0

func update_label(_joypad):
	if is_inside_tree():
		$Label.text = get_tree().get_first_node_in_group("PauseSettingButton").button.text

func _on_tree_entered():
	update_label(false)
