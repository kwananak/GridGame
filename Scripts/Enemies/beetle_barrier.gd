extends "res://Scripts/Enemies/byte_barrier.gd"


func _ready():
	tile_type = "beetle"
	super._ready()

func hit_by_player(hit):
	if hit is int:
		return
	super.hit_by_player(hit)
