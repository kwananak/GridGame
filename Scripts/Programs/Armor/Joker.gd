extends "res://Scripts/Programs/program.gd"

func _ready():
	super._ready()
	usable = true

func action():
	virtual_level_manager.invincible = true
	usable = false
	duration = 3
	$Label.text = str(duration)
	$Label.show()
	add_to_group("EndTurn")

func turn_call():
	duration -= 1
	$Label.text = str(duration)
	if duration <= 0:
		virtual_level_manager.invincible = false
		$Label.hide()
