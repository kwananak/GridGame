extends Node

enum Artefact {GLOVES, ARMOR, GOGGLES, BRAIN, BOOTS}

var owned_artefacts = []
var equipped_artefact

# adds picked artefact to owned artefact list
func add_artefact(artefact):
	owned_artefacts.push_front(artefact)
	equipped_artefact = owned_artefacts[0]
	for n in owned_artefacts:
		if n == Artefact.GLOVES:
			$GlovesSprite.visible = true

# returns strength based on possessed artefacts
func get_strength():
	if equipped_artefact == Artefact.GLOVES:
		return 2
	else:
		return 1

# debug function to clear artefacts
func _on_reset_artefacts_pressed():
	owned_artefacts = []
	equipped_artefact = null
	for n in get_children():
		n.visible = false
