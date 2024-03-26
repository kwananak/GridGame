extends Area2D

@export_enum("Yellow", "Red") var type : String
var doom_wall

func _ready():
	$Sprite.frame = int(position.x / 32) % 5 + int(position.y / 32) % 5
	doom_wall = get_tree().get_first_node_in_group("DoomWall")

func _on_area_entered(area):
	match type:
		"Yellow":
			if area.is_in_group("VirtualPlayer"):
				get_tree().get_first_node_in_group("VirtualLevelManager").doomwall_state = "careful"
			for n in get_tree().get_nodes_in_group("YellowWarning"):
				n.queue_free()
		"Red":
			if area.is_in_group("VirtualPlayer"):
				get_tree().get_first_node_in_group("VirtualLevelManager").doomwall_state = "danger"
			for n in get_tree().get_nodes_in_group("RedWarning"):
				n.queue_free()
