extends "res://Scripts/Superclasses/Interactable.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var locked = true
export var open = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CollisionShape2D.disabled = open
	if open:
		$Sprite.frame = 1
	else:
		$Sprite.frame = 0
		
# Interactable API:
func ObjectsToInteractWith():
	return ["Player"]
		
func Interacting(_obj, overlap):
	if "Player" == overlap.get_node('..').name:
		if not locked:
			open = not open
		else:
			for N in overlap.get_node('..').get_children():
				if "CrowBar" in N.name:
					open = true
