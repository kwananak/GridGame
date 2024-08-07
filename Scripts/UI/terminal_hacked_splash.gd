extends Node2D

var done = false

func _ready():
	$Label.text = $/root/Main.get_level_name($/root/Main.real_scene.get_node("RealLevelManager").level_number) + " Terminal Hacked"
	global_position = get_tree().get_first_node_in_group("Camera").global_position
	await create_tween().tween_property(self, "scale", Vector2(1.0, 1.0), 0.5).finished
	done = true

func _process(_delta):
	if !done:
		return
	if Input.is_action_pressed("ui_accept") || Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		get_tree().get_first_node_in_group("ReturnButton").grab_focus()
		queue_free()
