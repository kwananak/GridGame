extends "res://Scripts/UI/dialogue.gd"

func _ready():
	super._ready()
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	player = get_tree().get_first_node_in_group("RealPlayer")
	dialog = progress_manager.dialogs[dialogue_number]["1"]["text"]
	highlight_color = progress_manager.dialogs[dialogue_number]["1"]["color"]

func trigger():
	spawn_bubble()

func spawn_bubble():
	bubble.global_position = player.position + Vector2(10, -40)
	bubble.show()
	bubble.play()
	await bubble.animation_finished
	write_bubble(0)
	label.show()
	button_sprite.show()
	animating = false

func remove_bubble():
	label.hide()
	button_sprite.hide()
	bubble.play_backwards()
	await bubble.animation_finished
	player.active = true
	queue_free()
