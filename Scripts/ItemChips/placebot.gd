extends "res://Scripts/ItemChips/item_chip.gd"

func _ready():
	info = "Placebot for Busque. When the player walks on it, it disappears"

# removes item
func pick_up(_area):
	queue_free()
