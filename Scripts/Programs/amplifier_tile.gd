extends "res://Scripts/Programs/program_tile.gd"

var opened = false
var progress_manager

@export_enum("NeuroEnhanceAmplifierA", "NeuroEnhanceAmplifierB", "NeuroEnhanceAmplifierC", "NeuroEnhanceAmplifierD") var select_amplifier : String

func _ready():
	progress_manager = get_tree().get_first_node_in_group("ProgressManager")
	for n in progress_manager.get_node("OwnedPrograms/Amplifiers").get_children():
		if n.name == select_amplifier:
			$ChestSprite.animation = "open"
			$ChestSprite.frame = 7
			opened = true
			return
	program_type = select_amplifier
	program_slot = "Amplifiers"
	super._ready()
	$AnimatedSprite2D/NameLabel.text = select_amplifier.substr(0, select_amplifier.length() - 1)
	$AnimatedSprite2D/NameLabel.add_theme_font_size_override("font_size", 28)

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
	$AnimatedSprite2D.show()
	$AudioStreamPlayer.play()
	$AnimatedSprite2D/AnimationPlayer.play("new_animation")
	await $AnimatedSprite2D/AnimationPlayer.animation_finished
	$AnimatedSprite2D/ButtonSprite.show()
	await remove
	program.scale = Vector2.ONE
	program.set_deferred("monitorable", false)
	$AnimatedSprite2D.remove_child(program)
	progress_manager.add_amplifier(program)
	$AnimatedSprite2D.hide()
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
