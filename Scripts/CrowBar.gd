extends Sprite


onready var Controls = get_node("/root/Controls")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var carried = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Controls.connect("player_interaction_requested", self, "_on_Controls_player_interaction_requested")

func _on_Controls_player_interaction_requested():
	if not carried:
		var overlap_areas = $InteractionRadius.get_overlapping_areas ( )
		if overlap_areas.size() > 0:
			for overlap in overlap_areas:
				if "Player" == overlap.get_node('..').name:
					get_node('..').remove_child(self)
					overlap.get_node('..').add_child(self)
					position=Vector2(-14,0)
					carried = true

