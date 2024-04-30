extends Area2D

var camera
var framed_checker
var cursor_timer
@onready var node_2d = $Node2D
@onready var sprite_2d = $Sprite2D
@onready var label = $Sprite2D/Label

# gets camera reference on ready
func _ready():
	camera = get_tree().get_first_node_in_group("Camera")
	framed_checker = get_tree().get_first_node_in_group("FramedChecker") 

# updates position to mouse position on each frame
func _process(delta):
	if cursor_timer:
		cursor_timer -= delta
		if cursor_timer < 0:
			cursor_timer = null
	position = (get_viewport().get_mouse_position() / 2) + (camera.position - (get_viewport_rect().size / 4))
	if has_overlapping_areas():
		if get_overlapping_areas().is_empty():
			return
		var area = get_overlapping_areas()[0]
		if area.get("info"):
			if !framed_checker.check(node_2d.global_position):
				sprite_2d.position = Vector2(20, 16) - (node_2d.global_position - framed_checker.keep_in_frame(node_2d.global_position))
			else:
				sprite_2d.position = Vector2(20, 16)
			var adjusted_name = area.name
			if "type" in area:
				adjusted_name = area.type
			if "type_as_string" in area:
				adjusted_name = area.type_as_string()
			while true:
				if adjusted_name.right(1).is_valid_int():
					adjusted_name = adjusted_name.left(-1)
				else:
					break
			label.text = adjusted_name + "\n" + area.info
			show()
	else:
		hide()

func _input(event):
	if cursor_timer:
		return
	if event is InputEventMouse:
		cursor_timer = 1.5
		if Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
			set_process(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		set_process(false)
		hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
