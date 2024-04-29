extends Node2D

signal done

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1.4).timeout
	$GodotSprite.hide()
	$BerlingotSprite.show()
	await get_tree().create_timer(1.7).timeout
	done.emit()
	queue_free()
