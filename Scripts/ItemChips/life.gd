extends "res://Scripts/ItemChips/item_chip.gd"

# set up number of lives added after pick up
@export var strength = 1

func _ready():
	super._ready()
	info = "Give +" + str(strength) + " life"

# adds strength to lives and removes item
func pick_up(area):
	if area.name != "Firewall":
		get_tree().get_first_node_in_group("VirtualLevelManager").lives += strength
	queue_free()
