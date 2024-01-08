extends "res://Scripts/ItemChips/item_chip.gd"

# set up number of action added after pick up
@export var strength = 1

func _ready():
	info = "Give +" + str(strength) + " action"

# adds strength to actions and removes item
func pick_up(area):
	if area.name != "Firewall":
		get_tree().get_first_node_in_group("VirtualLevelManager").remaining_actions += strength
	queue_free()
