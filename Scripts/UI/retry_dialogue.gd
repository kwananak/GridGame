extends "res://Scripts/UI/dialogue_area.gd"

func _ready():
	camera = get_tree().get_first_node_in_group("Camera")
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	dialog = progress_manager.dialogs["RW1"]["1"]["text"]
	highlight_color = progress_manager.dialogs["RW1"]["1"]["color"]

func remove_bubble():
	label.hide()
	button_sprite.hide()
	bubble.play_backwards()
	await bubble.animation_finished
	bubble.hide()
	await create_tween().tween_property(camera, "position", level_manager.out_of_bounds_check(player.position), 0.4 * camera_speed).finished
	level_manager.dialogue = false
	player.get_node("PossibleMoves").show()
	queue_free()
