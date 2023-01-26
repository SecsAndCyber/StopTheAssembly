extends AnimatedSprite

onready var Controls = get_node("/root/Controls")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var AC = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Controls.connect("ac_changed", self, "_on_Controls_ac_changed")

func _on_Controls_ac_changed(state):
	AC = state

var next_frame = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if next_frame < OS.get_system_time_msecs():
		next_frame = OS.get_system_time_msecs() + 250
		if AC:
			frame = wrapi(frame + 1, 1, 3)
		else:
			frame = 0
