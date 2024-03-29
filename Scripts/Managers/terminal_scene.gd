extends Control

var loadout
var loaded_level = null
var terminal_number

@onready var terminal_name = $Map/MapInfos/TerminalName
@onready var main = $/root/Main

func _ready():
	loadout = get_tree().get_first_node_in_group("ProgressManager").get_node("Loadout")
	terminal_number = name.substr(name.length() - 1)
	terminal_name.text = main.get_level_name(main.real_scene.get_node("RealLevelManager").level_number)
	await get_tree().get_first_node_in_group("ProgressManager").auto_loader()
	_on_visibility_changed()
	await get_tree().create_timer(0.5).timeout
	$ReturnButton.grab_focus()

func _input(event):
	if visible == false:
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
	else:
		$NexusButton.available = false

func _on_go_button_pressed():
	if loaded_level == null:
		return
	loadout.hide()
	main.call_level(loaded_level)
	visible = false

func _on_visibility_changed():
	if visible:
		var prog_man = get_tree().get_first_node_in_group("ProgressManager")
		for n in $Map.get_children():
			if n.name == "MapInfos":
				continue
			if n.selected:
				n.selected = false
			if str(n.node_level) in prog_man.completed_levels:
				n.completed = true
			if str(n.node_level) in prog_man.unlocked_levels:
				n.available = true
		for n in prog_man.get_children():
			for o in n.get_children():
				for p in o.get_children():
					p.monitorable = false
					p.get_node("Sprite2D").show()
		loaded_level = null
		if terminal_number != null:
			$Log.hide()
			$Loadout.show()
			$AudioStreamPlayer.play()
			$DoorLabel/Label.clear()
			$DoorLabel/Label.append_text("[center]")
			for i in prog_man.doors:
				if int(i) == int(terminal_number) + 1:
					open_door_sprite()
					$DoorLabel/Label.append_text("[color=green]Terminal " + str(terminal_number) + "\nunlocked")
					return
				if has_node("GateLabel"):
					if int(i) == 5:
						open_gate_sprite()
						$GateLabel/Label.clear()
						$GateLabel/Label.append_text("[center][color=green]Gate unlocked")
			$DoorLabel/Label.append_text("[color=red]Terminal " + str(terminal_number) + "\nlocked")
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
