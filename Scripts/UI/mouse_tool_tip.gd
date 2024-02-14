extends Area2D

var camera

# gets camera reference on ready
func _ready():
	camera = get_tree().get_first_node_in_group("Camera")

# updates position to mouse position on each frame
func _process(_delta):
	position = (get_viewport().get_mouse_position() / 2) + (camera.position - (get_viewport_rect().size / 4)) - Vector2(0, 32)
	if has_overlapping_areas():
		if get_overlapping_areas().is_empty():
			return
		var area = get_overlapping_areas()[0]
		if area.get("info"):
			var adjusted_name = area.name
			while true:
				if adjusted_name.right(1).is_valid_int():
					adjusted_name = adjusted_name.left(-1)
				else:
					break
			$Label.text = adjusted_name + "\n" + area.info
			show()
	else:
		hide()
