extends AnimatedSprite


onready var Controls = get_node("/root/Controls")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var on = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Controls.connect("player_interaction_requested", self, "_on_Controls_player_interaction_requested")
	Controls.connect("ac_changed", self, "_on_Controls_ac_changed")

func _process(_delta):
	if on:
		frame = 0
	else:
		frame = 1

func _on_Controls_player_interaction_requested():
	var overlap_areas = $InteractionRadius.get_overlapping_areas ( )
	if overlap_areas.size() > 0:
		for overlap in overlap_areas:
			if "Player" == overlap.get_node('..').name:
				on = not on
				Controls.ac_changed(on)

func _on_Controls_ac_changed(state):
	on = state
