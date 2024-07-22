extends "res://Scripts/UI/real_ui.gd"

func _ready():
	vignette = get_tree().get_first_node_in_group("Level1Vignette")
	super._ready()
