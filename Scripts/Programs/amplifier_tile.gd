extends "res://Scripts/Programs/program_tile.gd"

var opened = false
var progress_manager

@export_enum("NeuroEnhanceAmplifierA", "NeuroEnhanceAmplifierB", "NeuroEnhanceAmplifierC", "NeuroEnhanceAmplifierD") var select_amplifier : String

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	for n in progress_manager.get_node("OwnedPrograms/Amplifiers").get_children():
		if n.type == select_amplifier:
			$ChestSprite.animation = "open"
			$ChestSprite.frame = 7
			opened = true
			return
	program_type = select_amplifier
	program_slot = "Amplifiers"
	super._ready()
	name_label.text = select_amplifier.substr(0, select_amplifier.length() - 1)
	name_label.add_theme_font_size_override("font_size", 28)

func pick_up(_area):
	if opened:
		return
	get_tree().get_first_node_in_group("RealPlayer").active = false
	get_tree().get_first_node_in_group("RealPlayer").get_node("AnimatedSprite2D").animation = "idle"
	get_tree().get_first_node_in_group("RealPlayer").get_node("AnimatedSprite2D").play()
	opened = true
	get_tree().get_first_node_in_group("MouseToolTip").hide()
	$ChestSprite.frame_changed.connect(chest_sounds)
	$ChestSprite.animation = "open"
	await $ChestSprite.animation_finished
	$Sprite2D.show()
	program.z_index = 91
	program.position = Vector2(-4.5, -3.0)
	program.scale = Vector2(0.45, 0.45)
	animation_player.stop()
	$AudioStreamPlayer.play()
	create_tween().tween_property($Sprite2D, "global_position", global_position + global_position.direction_to(get_tree().get_first_node_in_group("Camera").global_position) * global_position.distance_to(get_tree().get_first_node_in_group("Camera").global_position) / 4, 1)
	await create_tween().tween_property($Sprite2D, "scale", Vector2(7, 7), 1).finished
	$Sprite2D/PickUp/ButtonSprite.show()
	await remove
	program.scale = Vector2.ONE
	program.set_deferred("monitorable", false)
	$Sprite2D.remove_child(program)
	progress_manager.add_amplifier(program)
	$Sprite2D.hide()
	if has_node("Dialogue"):
		$Dialogue.trigger()
		return
	get_tree().get_first_node_in_group("RealPlayer").active = true

func _on_mouse_entered():
	pass

func _on_mouse_exited():
	pass

func chest_sounds():
	match $ChestSprite.frame:
		0, 2, 4:
			$DingChest.play()
		5:
			$OpenChest.play()
			$ChestSprite.frame_changed.disconnect(chest_sounds)
