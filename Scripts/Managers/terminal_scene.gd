extends Node2D

var loaded_level = null
var terminal_number
var prog_man

@onready var terminal_name = $Control/Map/MapInfos/TerminalName
@onready var main = $/root/Main

func _ready():
	prog_man = get_tree().get_first_node_in_group("ProgressManager")
	terminal_number = name.substr(name.length() - 1)
	terminal_name.text = main.get_level_name(main.real_scene.get_node("RealLevelManager").level_number)
	_on_visibility_changed()
	await get_tree().create_timer(0.5).timeout
	$Control/ReturnButton.grab_focus()

func _input(event):
	if visible == false:
		return
	if event.is_action_pressed("pause"):
		_on_return_button_pressed()

# called by return button to send the player back to the real world
func _on_return_button_pressed():
	prog_man.hide()
	main.return_to_real_scene()

func _on_level_pressed(level_number):
	loaded_level = level_number
	if level_number:
		$Control/NexusButton.available = true
	else:
		$Control/NexusButton.available = false

func _on_go_button_pressed():
	if loaded_level == null:
		return
	prog_man.hide()
	main.call_level(loaded_level)
	visible = false

func _on_visibility_changed():
	if !prog_man:
		return
	if visible:
		for n in $Control/Map.get_children():
			if n.name == "MapInfos" :
				continue
			if n.selected:
				n.selected = false
			if str(n.node_level) in prog_man.completed_levels:
				n.completed = true
			if str(n.node_level) in prog_man.unlocked_levels:
				n.available = true
		for n in prog_man.get_children():
			for o in n.get_children():
				o.monitorable = false
		loaded_level = null
		if terminal_number != null:
			$AudioStreamPlayer.play()
			$Control/DoorLabel/Label.clear()
			$Control/DoorLabel/Label.append_text("[center]")
			for i in prog_man.doors:
				if int(i) == int(terminal_number) + 1:
					$Control/DoorLabel/Sprite.play()
					$Control/DoorLabel/Label.append_text("[color=green]Terminal " + str(terminal_number) + "\nunlocked")
					return
			$Control/DoorLabel/Label.append_text("[color=red]Terminal " + str(terminal_number) + "\nlocked")
	else:
		$AudioStreamPlayer.stop()
