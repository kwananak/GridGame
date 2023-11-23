extends Area2D

var tile_type = "artefact"
enum Artefact {GLOVES, ARMOR, GOGGLES, BRAIN, BOOTS}

@export var artefact_type : Artefact

# calls artefact holder to add picked up artefact to the list
func pick_up():
	get_node("/root/Main/ArtefactHolder").add_artefact(artefact_type)
	queue_free()
