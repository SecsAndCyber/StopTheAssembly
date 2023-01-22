extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Controls = get_node("/root/Controls")

# Called when the node enters the scene tree for the first time.
func _ready():
	Controls.connect("time_changed", self, "_on_Controls_time_changed")
	Controls.connect("temp_changed", self, "_on_Controls_temp_changed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_Controls_time_changed(hour,minute):#
	$Clock.text = "%2d:%02d" % [hour,minute]
	
func _on_Controls_temp_changed(degrees):#
	$Temperature.text = "%2d° F" % [degrees]
