extends Area2D

var on = false
var level_manager

@export var unlocks : int

@onready var audio = $AnimatedSprite2D/AudioStreamPlayer2D

func _ready():
	level_manager = get_tree().get_first_node_in_group("VirtualLevelManager")

func _on_area_entered(area):
	if !on:
		return
	level_manager.on_success(unlocks)
	area.return_animation()

func _on_animated_sprite_2d_visibility_changed():
	audio.play()
	await get_tree().create_timer(2).timeout
	if is_inside_tree():
		audio.play()
