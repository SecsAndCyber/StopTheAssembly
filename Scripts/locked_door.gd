extends StaticBody2D

onready var Controls = get_node("/root/Controls")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var locked = true
export var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Controls.connect("player_interaction_requested", self, "_on_Controls_player_interaction_requested")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CollisionShape2D.disabled = open
	if open:
		$Sprite.frame = 1
	else:
		$Sprite.frame = 0
		
func _on_Controls_player_interaction_requested():
	var overlap_areas = $InteractionRadius.get_overlapping_areas ( )
	if overlap_areas.size() > 0:
		for overlap in overlap_areas:
			if "Player" == overlap.get_node('..').name:
				if not locked:
					open = not open
