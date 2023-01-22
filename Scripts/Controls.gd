extends Node

signal player_move(direction)
signal player_interaction_requested()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var current_movement_direction = Vector2.ZERO
		
func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("Interaction")
		emit_signal("player_interaction_requested")
		
func _physics_process(_delta):
	var move_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		move_direction += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		move_direction += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		move_direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		move_direction += Vector2.RIGHT
		
	if not move_direction == Vector2.ZERO:
		emit_signal("player_move", move_direction)
	
