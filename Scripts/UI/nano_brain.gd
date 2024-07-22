extends "res://Scripts/UI/dialogue.gd"

var done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")
	player = get_tree().get_first_node_in_group("VirtualPlayer")
	dialog = progress_manager.dialogs["RW6"]["1"]["text"]

func _on_area_entered(_area):
	level_manager.game_over = true
	trigger()
	$"../UI".z_index = 30
	$"../ColorRect/AnimationPlayer".play("fade_out")

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

func write_bubble(sentence):
	writing = true
	label.clear()
	if sentence % 2 == 0:
		label.append_text("[color=aqua]")
		audio = $Brain
	else:
		label.append_text("[color=purple]")
		audio = $Player
	for i in dialog[sentence]:
		label.append_text(i)
		while level_manager.paused:
			if is_inside_tree():
				await get_tree().create_timer(0.2).timeout
		if writing:
			if is_inside_tree():
				if audio:
					match i:
						" ", ",", ".", "'", "!", "?", "’":
							pass
						_:
							if audio.name == "Player":
								audio.pitch_scale = float(i.to_lower().to_ascii_buffer()[0]) / 100
							audio.play()
				await get_tree().create_timer(1.0 / text_speed).timeout
	writing = false

func remove_bubble():
	animating = true
	$"../ColorRect2/AnimationPlayer".play("fade_out")
	await $"../ColorRect2/AnimationPlayer".animation_finished
	$/root/Main.call_cutscene(5)
