extends Control

var loadout
var loaded_level = null
var terminal_number
var splash
var progress_manager

@onready var hack_splash = preload("res://Scenes/TerminalElements/terminal_hacked_splash.tscn")
@onready var terminal_name = $MapBackground/TerminalName
@onready var main = $/root/Main

func _ready():
	progress_manager = get_parent().get_node("ProgressManager")
	loadout = progress_manager.get_node("Loadout")
	terminal_number = name.substr(name.length() - 1)
	terminal_name.text = main.get_level_name(main.real_scene.get_node("RealLevelManager").level_number)
	await progress_manager.auto_loader()
	_on_visibility_changed()

func _input(event):
	if !visible:
		return
	if event.is_action_pressed("pause"):
		_on_return_button_pressed()

# called by return button to send the player back to the real world
func _on_return_button_pressed():
	loadout.hide()
	main.return_to_real_scene()

func _on_level_pressed(level_number):
	loaded_level = level_number
	if level_number:
		$NexusButton.available = true
		$NexusButton.grab_focus()
	else:
		$NexusButton.available = false

func _on_go_button_pressed():
	if !loaded_level:
		return
	loadout.hide()
	main.call_level(loaded_level)
	visible = false

func nodes_refresh():
	var completed = true
	if $ReturnButton.is_inside_tree():
		$ReturnButton.grab_focus()
	for n in $Map.get_children():
		if n.name == "MapInfos":
			continue
		if n.selected:
			n.selected = false
		if str(n.node_level) in progress_manager.completed_levels:
			n.completed = true
			if n.node_level == progress_manager.last_level_completed:
				if n.is_inside_tree():
					n.grab_focus()
		else:
			completed = false
		if str(n.node_level) in progress_manager.unlocked_levels:
			n.available = true
	if completed:
		if !splash:
			splash = load("res://Scenes/TerminalElements/terminal_hacked_splash.tscn").instantiate()
			if has_node("HackSplash"):
				$HackSplash.add_child(splash)
			else:
				add_child(splash)
		if get_viewport().gui_get_focus_owner():
			get_viewport().gui_get_focus_owner().release_focus()

func _on_visibility_changed():
	if !progress_manager:
		return
	if visible:
		await nodes_refresh()
		for n in progress_manager.get_children():
			for o in n.get_children():
				for p in o.get_children():
					p.monitorable = false
					p.get_node("Sprite2D").show()
					if p.type == progress_manager.just_unlocked:
						await new_program_animation(p)
						progress_manager.just_unlocked = null
		loaded_level = null
		if terminal_number != null:
			$Log.hide()
			$Loadout.show()
			$AudioStreamPlayer.play()
			if !has_node("DoorLabel"):
				return
			$DoorLabel/Label.clear()
			$DoorLabel/Label.append_text("[center]")
			for i in progress_manager.doors:
				if int(i) == int(terminal_number) + 1:
					open_door_sprite()
					$DoorLabel/Label.append_text("[color=green]unlocked")
					return
				if has_node("GateLabel"):
					if int(i) == 5:
						open_gate_sprite()
						$GateLabel/Label.clear()
						$GateLabel/Label.append_text("[center][color=green]unlocked")
			$DoorLabel/Label.append_text("[color=red]locked")
	else:
		$AudioStreamPlayer.stop()

func open_gate_sprite():
	var door_sprite = $GateLabel/Sprite
	door_sprite.play()
	await door_sprite.animation_finished
	door_sprite.play("opened")

func open_door_sprite():
	var door_sprite = $DoorLabel/Sprite
	door_sprite.play()
	await door_sprite.animation_finished
	door_sprite.play("opened")

func new_program_animation(program):
	var stored_focus = get_viewport().gui_get_focus_owner()
	stored_focus.release_focus()
	program.z_index = 90
	program.global_position = get_tree().get_first_node_in_group("Camera").global_position
	$ProgramAdded.play()
	await create_tween().tween_property(program, "scale", program.scale * 3, 1.0).finished
	await get_tree().create_timer(1.0).timeout
	create_tween().tween_property(program, "position", Vector2.ZERO, 1.0)
	await create_tween().tween_property(program, "scale", Vector2.ONE, 1.0).finished
	program.z_index = 0
	stored_focus.grab_focus()
