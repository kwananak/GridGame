extends Area2D

@export var unlocks : int

var level_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

func _on_area_entered(area):
	level_manager.on_success(unlocks)
	area.death_animation()
