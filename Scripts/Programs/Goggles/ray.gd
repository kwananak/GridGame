extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Freeze all enemies for 5 turns"
	super._ready()

func loaded():
	active = true
	super.loaded()

func action():
	if level_manager.freeze < 1:
		level_manager.freeze = 5
		add_to_group("Freeze")
		$Label.text = str(level_manager.freeze)
		$Label.show()
		usable = false

func turn_call():
	if level_manager.freeze < 1:
		remove_from_group("Freeze")
		$Label.hide()
		usable = true
		return
	$Label.text = str(level_manager.freeze)
