extends Node2D

@onready var main = $/root/Main
@onready var go = $Control/GoButton
var loadout
var loaded_level = null

func _ready():
	go.grab_focus()
	loadout = get_tree().get_first_node_in_group("ProgressManager").get_node("Loadout")

func _input(event):
	if visible == false:
		return
	if event.is_action_pressed("pause"):
		_on_return_button_pressed()

# called by return button to send the player back to the real world
func _on_return_button_pressed():
	loadout.hide()
	main.return_to_real_scene()
	queue_free()

func _on_level_pressed(level_number):
	loaded_level = level_number
	go.text = "Level " + str(level_number)

func _on_go_button_pressed():
	if loaded_level == null:
		return
	loadout.hide()
	$/root/Main.call_level(loaded_level)
	visible = false

func _on_visibility_changed():
	if visible:
		for n in get_tree().get_first_node_in_group("ProgressManager").get_children():
			for o in n.get_children():
				for p in o.get_children():
					p.monitorable = false
		loaded_level = null
		if go:
			go.text = "choose\nlevel"
	else:
		for n in get_tree().get_first_node_in_group("ProgressManager").get_children():
			for o in n.get_children():
				for p in o.get_children():
					p.monitorable = true
