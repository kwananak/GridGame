extends "res://Scripts/ItemChips/item_chip.gd"

func _ready():
	info = "Placébot for Busque. When the player go on it, it disapear"

# removes item
func pick_up(_area):
	queue_free()
