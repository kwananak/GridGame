extends Area2D

@export var unlocks : int

var on = false

var level_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

func _on_area_entered(area):
	if !on:
		return
	level_manager.on_success(unlocks)
	area.death_animation()
