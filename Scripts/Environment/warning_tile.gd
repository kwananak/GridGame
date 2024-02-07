extends Area2D

@export_enum("Yellow", "Red") var type : String

func _ready():
	$Sprite.frame = int(position.x / 32) % 5 + int(position.y / 32) % 5

func _on_area_entered(area):
	match type:
		"Yellow":
			if area.is_in_group("VirtualPlayer"):
				get_tree().get_first_node_in_group("DoomWall").step = get_tree().get_first_node_in_group("VirtualLevelManager").yellow_doomwall_step
				get_tree().get_first_node_in_group("WarningUI").frame = 1
				get_tree().get_first_node_in_group("BackgroundColors").get_node("Careful").visible = true
			for n in get_tree().get_nodes_in_group("YellowWarning"):
				n.queue_free()
		"Red":
			if area.is_in_group("VirtualPlayer"):
				get_tree().get_first_node_in_group("DoomWall").step = get_tree().get_first_node_in_group("VirtualLevelManager").red_doomwall_step
				get_tree().get_first_node_in_group("WarningUI").frame = 2
				get_tree().get_first_node_in_group("BackgroundColors").get_node("Careful").visible = false
				get_tree().get_first_node_in_group("BackgroundColors").get_node("Danger").visible = true
			for n in get_tree().get_nodes_in_group("RedWarning"):
				n.queue_free()
