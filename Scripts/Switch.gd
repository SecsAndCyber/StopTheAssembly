extends "res://Scripts/Superclasses/Interactable.gd"

export var on = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Controls.connect("ac_changed", self, "_on_Controls_ac_changed")

func _process(_delta):
	if on:
		$Sprite.frame = 0
	else:
		$Sprite.frame = 1

# Interactable API:
func ObjectsToInteractWith():
	return ["Player"]
		
func Interacting(_obj, overlap):
	if "Player" == overlap.get_node('..').name:
		on = not on
		Controls.ac_changed(on)

func _on_Controls_ac_changed(state):
	on = state
