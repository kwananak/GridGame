extends Area2D

var tile_type = "program"

@export_enum("DamnedGauntlet", "DestroyerGlove", "CircleWhip", "ChillingLance", "GrapplingTool", "1-0-1Shotgun") var hand_type : String

func _ready():
	$AnimatedSprite2D.animation = hand_type

# calls progress manager to add picked up program to the list
func pick_up():
	$/root/Main/ProgressManager.add_to_programs("Hands", hand_type)
	queue_free()
