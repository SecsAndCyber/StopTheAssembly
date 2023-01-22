extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var next_scene = "res://Scenes/EndGames/Menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	_next_scene()
	
func _next_scene():
	yield(get_tree().create_timer(2), "timeout")
	var _change = get_tree().change_scene(next_scene)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			var _change = get_tree().change_scene(next_scene)
