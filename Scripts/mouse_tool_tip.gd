extends Area2D

var camera

# gets camera reference on ready
func _ready():
	camera = get_tree().get_first_node_in_group("Camera")

# updates position to mouse position on each frame
func _process(_delta):
	position = (get_viewport().get_mouse_position() / 2) + (camera.position - (get_viewport_rect().size / 4)) - Vector2(0, 32)

# gets info from program when hovering
func _on_area_entered(area):
	if area.get("info"):
		$Label.text = area.name + "\n" + area.info
		show()

# hides tool tip when not hovering
func _on_area_exited(_area):
	hide()
