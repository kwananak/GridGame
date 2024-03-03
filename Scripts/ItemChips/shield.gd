extends "res://Scripts/ItemChips/item_chip.gd"

# set up number of shields added after pick up
@export var strength = 1

func _ready():
	super._ready()
	info = "Give +" + str(strength) + " shield"
	if strength > 1:
		info += "s"

# adds strength to shields and removes item
func pick_up(area):
	if area.name != "DoomWall":
		var diamond_armor = get_tree().get_first_node_in_group("DiamondArmor")
		if diamond_armor:
			if diamond_armor.used != 0:
				get_tree().get_first_node_in_group("VirtualLevelManager").shields += strength
				diamond_armor.used -= 1
				$Audio.play()
				hide()
				await $Audio.finished
		else:
			get_tree().get_first_node_in_group("VirtualLevelManager").shields += strength
			$Audio.play()
			hide()
			await $Audio.finished
	queue_free()
