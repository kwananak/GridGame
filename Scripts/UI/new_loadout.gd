extends Sprite2D

var prog_load

func _ready():
	prog_load = get_tree().get_first_node_in_group("ProgressManager")
	set_slots()

func set_slots():
	prog_load.show()
	for n in get_children():
		match n.name:
			"Background":
				continue
			_:
				var v = prog_load.get_node(str(n.name))
				v.global_position = n.global_position + Vector2(22, 22)
				v.scale = Vector2(1.3, 1.3)
