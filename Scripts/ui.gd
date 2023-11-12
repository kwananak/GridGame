extends Node2D

@onready var lm = $"../LevelManager" 



func _on_button_pressed():
	lm._on_button_pressed()
