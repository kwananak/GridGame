extends Area2D

var on = false

func _on_area_entered(_area):
	if !on:
		return
	get_tree().get_first_node_in_group("VirtualLevelManager").game_over = true
	$Sprite2D.global_position = get_tree(). get_first_node_in_group("Camera").global_position
	$Sprite2D.show()
	$Sprite2D/Menu.grab_focus()

func _on_menu_button_down():
	get_tree().get_first_node_in_group("VirtualLevelManager").call_menu()
