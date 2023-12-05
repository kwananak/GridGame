extends Area2D
 
var speed = 500

func _input(event):
	if event is InputEventMouse:
		position = event.position / 2


func _on_area_entered(area):
	if area.get("info"):
		$Label.text = area.name + "\n" + area.info
		show()


func _on_area_exited(_area):
	hide()
