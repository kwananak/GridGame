extends Area2D
 
var speed = 500
var camera
const SPEED = 500

func _process(delta):
	position = (get_viewport().get_mouse_position() / 2) + (camera.position - get_viewport_rect().size / 4) - Vector2(0, 32)

func _ready():
	camera = get_tree().get_first_node_in_group("Camera")


func _on_area_entered(area):
	if area.get("info"):
		$Label.text = area.name + "\n" + area.info
		show()


func _on_area_exited(_area):
	hide()
