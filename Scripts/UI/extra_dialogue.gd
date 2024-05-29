extends "res://Scripts/UI/dialogue.gd"

var speed = 0.4

func _ready():
	await super._ready()
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	player = get_tree().get_first_node_in_group("RealPlayer")
	dialog = progress_manager.dialogs[dialogue_number]["1"]["text"]
	if dialogue_number in progress_manager.log_progress:
		queue_free()

func spawn_bubble():
	player.animated_sprite_2d.play("idle")
	player.active = false
	bubble.global_position = camera.position + Vector2(0, 800)
	bubble.show()
	write_bubble(0)
	label.show()
	await create_tween().tween_property(bubble, "global_position", camera.position, speed).finished
	$AnimatedSprite2D.hide()
	await get_tree().create_timer(0.5).timeout
	animating = false

func remove_bubble():
	await create_tween().tween_property(bubble, "global_position", camera.position + Vector2(0, 800), speed).finished
	progress_manager.log_progress[dialogue_number] = false
	player.active = true
	queue_free()

func _on_body_entered(_body):
	spawn_bubble()

func write_bubble(sentence):
	writing = true
	label.clear()
	var bolded = false
	for i in dialog[sentence]:
		if i == "$":
			if !bolded:
				if !highlight_color:
					highlight_color = "red"
				label.append_text("[color=" + highlight_color + "]")
				bolded = true
			else:
				label.append_text("[color=white]")
				bolded = false
			continue
		if i == "%":
			label.append_text("\n\n")
			continue
		label.append_text(i)
	writing = false
