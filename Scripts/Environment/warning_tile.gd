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
				doom_wall.get_node("AudioStreamPlayer").play()
				doom_wall.step = get_tree().get_first_node_in_group("VirtualLevelManager").yellow_doomwall_step
				doom_wall.state = "carefull"
				get_tree().get_first_node_in_group("WarningUI").play("yellow")
				get_tree().get_first_node_in_group("BackgroundColors").get_node("Careful").visible = true
			for n in get_tree().get_nodes_in_group("YellowWarning"):
				n.queue_free()
		"Red":
			if area.is_in_group("VirtualPlayer"):
				doom_wall.get_node("AudioStreamPlayer").play()
				doom_wall.step = get_tree().get_first_node_in_group("VirtualLevelManager").red_doomwall_step
				doom_wall.state = "danger"
				get_tree().get_first_node_in_group("WarningUI").play("red")
				get_tree().get_first_node_in_group("BackgroundColors").get_node("Careful").visible = false
				get_tree().get_first_node_in_group("BackgroundColors").get_node("Danger").visible = true
			for n in get_tree().get_nodes_in_group("RedWarning"):
				n.queue_free()
