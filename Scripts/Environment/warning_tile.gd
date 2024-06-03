extends Area2D

func _ready():
	$Sprite.frame = int(position.x / 32) % 5 + int(position.y / 32) % 5

func _on_area_entered(_area):
	match name.substr(0, 3):
		"Yel":
			get_tree().get_first_node_in_group("VirtualLevelManager").doomwall_state = "careful"
			for n in get_tree().get_nodes_in_group("YellowWarning"):
				n.queue_free()
		"Red":
			get_tree().get_first_node_in_group("VirtualLevelManager").doomwall_state = "danger"
			for n in get_tree().get_nodes_in_group("YellowWarning") + get_tree().get_nodes_in_group("RedWarning"):
				n.queue_free()
		"Aqu":
			get_tree().get_first_node_in_group("VirtualLevelManager").doomwall_state = "extreme"
			for n in get_tree().get_nodes_in_group("YellowWarning") + get_tree().get_nodes_in_group("RedWarning") + get_tree().get_nodes_in_group("AquaWarning"):
				n.queue_free()
