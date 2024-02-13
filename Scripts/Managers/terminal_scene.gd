extends Node2D

var loadout
var loaded_level = null
var terminal_number

@onready var terminal_name = $Control/Map/MapInfos/TerminalName
@onready var main = $/root/Main

func _ready():
	loadout = get_tree().get_first_node_in_group("ProgressManager").get_node("Loadout")
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
	loadout.hide()
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
	loadout.hide()
	main.call_level(loaded_level)
	visible = false

func _on_visibility_changed():
	if visible:
		var prog_man = get_tree().get_first_node_in_group("ProgressManager")
		for n in $Control/Map.get_children():
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
		loaded_level = null
		if terminal_number != null:
			$AudioStreamPlayer.play()
			$Control/DoorLabel/Label.text = "Terminal" + str(terminal_number) +"\n"
			for i in prog_man.doors:
				if int(i) == int(terminal_number) + 1:
					$Control/DoorLabel/Sprite.play()
					$Control/DoorLabel/Label.text += "unlocked"
					return
			$Control/DoorLabel/Label.text += "locked"
	else:
		$AudioStreamPlayer.stop()
