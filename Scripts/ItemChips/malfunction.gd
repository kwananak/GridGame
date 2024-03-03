extends "res://Scripts/ItemChips/item_chip.gd"

# set up number of turn freezed after pick up, turn where item is picked up is included
@export var strength = 3

func _ready():
	super._ready()
	info = "Freeze the DoomWall for " + str(strength) + " turns"

# sends freeze strength to firewall and removes item
func pick_up(area):
	if area.is_in_group("VirtualPlayer"):
		get_tree().get_first_node_in_group("DoomWall").freeze = strength
		$Audio.play()
		hide()
		await $Audio.finished
	queue_free()
