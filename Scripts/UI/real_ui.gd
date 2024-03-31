extends Node2D

var level_manager
var saved_vignette_scale_value
var vignette_scale = 0.0

@onready var main = $/root/Main
@onready var vignette = $Vignette
@onready var button = $Button

func _ready():
	level_manager = get_tree().get_first_node_in_group("RealLevelManager")
	saved_vignette_scale_value = vignette.material.get_shader_parameter("SCALE")
	vignette.material.set_shader_parameter("SCALE", vignette_scale)
	show()

func _process(delta):
	if vignette_scale < saved_vignette_scale_value:
		vignette_scale += 1.5 * delta
		vignette.material.set_shader_parameter("SCALE", vignette_scale)

func _input(event):
	if !button.visible:
		return
	if event.is_action_pressed("ui_accept"):
		level_manager._on_button_pressed()
		return
	if event is InputEventMouseButton:
		if event.is_pressed() && event.button_index == 1:
			level_manager._on_button_pressed()
