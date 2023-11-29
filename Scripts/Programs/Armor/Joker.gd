extends "res://Scripts/Programs/program.gd"

func _ready():
	info = "Action : Become invincible for 3 turn"
	super._ready()
	usable = true

func action():
	level_manager.invincible = true
	usable = false
	duration = 3
	$Label.text = str(duration)
	$Label.show()
	add_to_group("EndTurn")

func turn_call():
	duration -= 1
	$Label.text = str(duration)
	if duration <= 0:
		level_manager.invincible = false
		$Label.hide()
