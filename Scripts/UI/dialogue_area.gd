extends "res://Scripts/UI/dialogue.gd"

func _ready():
	super._ready()
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	dialog = progress_manager.dialogs[str(level_manager.level_number)][dialogue_number]["text"]
	highlight_color = progress_manager.dialogs[str(level_manager.level_number)][dialogue_number]["color"]
	if str(level_manager.level_number) not in progress_manager.log_progress:
		progress_manager.log_progress[str(level_manager.level_number)] = []
	if level_manager.skip_dialogues || dialogue_number in progress_manager.log_progress[str(level_manager.level_number)]:
		queue_free()
		return

func _on_area_entered(_area):
	trigger()

func close():
	if animating:
		return
	if writing:
		writing = false
		return
	if broadcasted < dialog.size():
		write_bubble(broadcasted)
		broadcasted += 1
		return
	remove_bubble()

func spawn_bubble():
	bubble.global_position = camera.position - Vector2(200, 300)
	bubble.show()
	var target_position = camera.position + Vector2(-200, 60)
	var target_speed = 0.4
	if player.global_position.y > camera.global_position.y + 60:
		target_position = camera.global_position + Vector2(-200, -100)
		target_speed = 0.2
	await create_tween().tween_property(bubble, "global_position", target_position, target_speed).finished
	bubble.get_node("Tail").hide()
	bubble.play()
	await bubble.animation_finished
	write_bubble(0)
	label.show()
	button_sprite.show()
	animating = false

func remove_bubble():
	if str(dialogue_number) not in progress_manager.log_progress[str(level_manager.level_number)]:
		progress_manager.log_progress[str(level_manager.level_number)] += [dialogue_number]
	if progress_manager.dialogs[str(level_manager.level_number)][dialogue_number]["log"]:
		get_tree().get_first_node_in_group("UI").add_child(log_flag.instantiate())
	label.hide()
	button_sprite.hide()
	bubble.play_backwards()
	await bubble.animation_finished
	bubble.hide()
	await create_tween().tween_property(camera, "position", level_manager.out_of_bounds_check(player.position), 0.4 * camera_speed).finished
	level_manager.dialogue = false
	player.get_node("PossibleMoves").show()
	queue_free()
