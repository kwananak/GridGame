extends Area2D

@export var text = "add Collision2D node and replace text with dialogue"

var level_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

func _on_area_entered(_area):
	level_manager.dialogue = true
	level_manager.paused = true
	$Label.text  = text
	$Label.global_position = get_tree().get_first_node_in_group("Camera").position + Vector2(-40, -80)
	$Label.show()
	$Label/Button.grab_focus()

func close():
	level_manager.dialogue = false
	level_manager.paused = false
	$Label/Button.release_focus()
	$Label.hide()
	queue_free()
