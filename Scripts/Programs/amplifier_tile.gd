extends "res://Scripts/Programs/program_tile.gd"

var opened = false

@export_enum("NeuroEnhanceAmplifier1", "NeuroEnhanceAmplifier2", "NeuroEnhanceAmplifier3", "NeuroEnhanceAmplifier4") var select_amplifier : String

func _ready():
	for n in get_tree().get_first_node_in_group("ProgressManager").get_node("Amplifiers").get_children():
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
	opened = true
	$ChestSprite.animation = "open"
	await $ChestSprite.animation_finished
	$AnimatedSprite2D.show()
	$AnimatedSprite2D/AnimationPlayer.play("new_animation")
	await get_tree().create_timer(3.2).timeout
	program.scale = Vector2.ONE
	program.set_deferred("monitorable", false)
	get_tree().get_first_node_in_group("MouseToolTip").hide()
	$AnimatedSprite2D.remove_child(program)
	get_tree().get_first_node_in_group("ProgressManager").add_amplifier(program)
	$AnimatedSprite2D.hide()

func _on_mouse_entered():
	pass

func _on_mouse_exited():
	pass
