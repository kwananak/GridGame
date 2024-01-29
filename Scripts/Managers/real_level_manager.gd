extends "res://Scripts/Managers/level_manager.gd"

var turn = 0

@onready var audio

func _ready():
	audio = get_parent().get_node("RealAudio")
	get_parent().remove_child.call_deferred(audio)
	if $/root/Main.has_node("RealAudio"):
		$/root/Main.remove_child($/root/Main/RealAudio)
	$/root/Main.add_child.call_deferred(audio)
	audio.play()
	player = get_tree().get_first_node_in_group("RealPlayer")
	super._ready()

func end_turn(_value):
	pass

# called by player when activating a terminal
func call_terminal(terminal_name):
	$/root/Main.call_terminal_scene(terminal_name)
