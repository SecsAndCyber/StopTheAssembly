extends PhysicsBody2D

onready var Controls = get_node("/root/Controls")

# Interactable API:
func ObjectsToInteractWith(): pass
		
func Interacting(_obj, _overlap): pass


func _ready():
	Controls.connect("player_interaction_requested", self, "_on_Controls_player_interaction_requested")
							
func _on_Controls_player_interaction_requested():
	var overlap_areas = $InteractionRadius.get_overlapping_areas ( )
	if overlap_areas.size() > 0:
		for overlap in overlap_areas:
			for obj in ObjectsToInteractWith():
				Interacting(obj, overlap)
