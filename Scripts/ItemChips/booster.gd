extends "res://Scripts/ItemChips/item_chip.gd"

# set up number of action added after pick up
@export var strength = 1
var picked = false

func _ready():
	super._ready()
	info = "Give +" + str(strength) + " action"

# adds strength to actions and removes item
func pick_up(area):
	if picked:
		return
	picked = true
	if area.is_in_group("VirtualPlayer"):
		get_tree().get_first_node_in_group("VirtualLevelManager").remaining_actions += strength
		$Audio.play()
		hide()
		await $Audio.finished
	queue_free()
