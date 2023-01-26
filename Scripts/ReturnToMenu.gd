extends Button

onready var Controls = get_node("/root/Controls")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var _connectd = connect("pressed", self, "_on_pressed")
	Controls.connect("player_interaction_requested", self, "_on_pressed")


func _on_pressed():
	print("pressed")
	Controls.GameStateChange(Controls.GAME_STATE_STARTED)


func _on_ReturnToMenu_pressed():
	_on_pressed()
