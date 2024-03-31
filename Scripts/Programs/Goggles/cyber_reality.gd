extends "res://Scripts/Programs/program.gd"

var doomwall
var distance = 5

func _ready():
	type = "CyberReality"
	info = "Action : Move the DoomWall back by " + str(distance) + " tiles."
	super._ready()
	doomwall = get_tree().get_first_node_in_group("DoomWall")

func loaded():
	active = true
	super.loaded()

func action():
	focus = true
	$LoadedSprite/Button.frame = 1
	player.moving = true
	doomwall.skip_turn = true
	var anim = player.get_node("AnimatedSprite2D")
	anim.flip_h = true
	anim.animation = "amazing"
	while true:
		await anim.frame_changed
		match anim.frame:
			2:
				$Audio.play()
			3:
				break
	doomwall.move_wall(-distance)
	await anim.animation_finished
	focus = false
	anim.animation = "idle"
	level_manager.end_turn()
