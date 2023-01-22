extends Node


# Declare member variables here. Examples:
onready var line : Line2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	line = get_node("../Line2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HallMonitor_path_changed(points):
	if line:
		line.points = points


func _on_HallMonitor2_path_changed(points):
	if line:
		line.points = points
