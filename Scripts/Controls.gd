extends Node

signal player_move(direction)
signal player_interaction_requested()
signal time_changed(hours,minutes)
signal temp_changed(degrees)
signal ac_changed(state)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var global_ac = true
export var emergency_temp = 115
export var ac_temp = 75
export var heat_step = 7
var global_temp = 75
onready var start_time_msecs = OS.get_system_time_msecs()
export var start_time = Vector2(8,30)
var time = Vector2.ZERO
var elapsed = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var current_movement_direction = Vector2.ZERO
		
func time_from_elaspsed():
	var minute = int(elapsed.y + start_time.y)
	var hour = elapsed.x + start_time.x + minute / 60
	minute = minute % 60
	return Vector2(hour,minute)
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("Interaction")
		emit_signal("player_interaction_requested")
		
func _process(_delta):
	var elaspsed_time = OS.get_system_time_msecs() - start_time_msecs
	var seconds_past = elaspsed_time / 1000
	var game_minutes_past = int((seconds_past / 60.0)*15)
	elapsed = Vector2(game_minutes_past / 60, game_minutes_past % 60)
	var now = time_from_elaspsed()
	
	if not time == now:
		time = now
		emit_signal("time_changed",time.x,time.y)
		
		if global_ac:
			global_temp = max(ac_temp, global_temp - heat_step)
			emit_signal("temp_changed", global_temp)
		else:
			global_temp = min(emergency_temp, global_temp + heat_step)
			emit_signal("temp_changed", global_temp)
			
	if global_temp >= emergency_temp:
		Controls.GameStateChange(Controls.GAME_STATE_TOO_HOT)
	if time.x >= 15:
		Controls.GameStateChange(Controls.GAME_STATE_END_OF_DAY)
		
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
	
func ac_changed(_bool):
	print("Controls.AC ", _bool)
	global_ac = _bool
	emit_signal("ac_changed", global_ac)
	
var GAME_STATE_STARTED = 0
var GAME_STATE_CUTSCREEN = 1
var GAME_STATE_TOO_HOT = 2
var GAME_STATE_ASSEMBLY = 3
var GAME_STATE_END_OF_DAY = 4
var GAME_STATE_OOB = 5

func GameStateChange(game_state):
	if game_state == GAME_STATE_STARTED:
		global_ac = true
		global_temp = 75
		start_time_msecs = OS.get_system_time_msecs()
		var _change = get_tree().change_scene("res://Scenes/EndGames/Menu.tscn")
	if game_state == GAME_STATE_OOB:
		var _change = get_tree().change_scene("res://Scenes/EndGames/Truant.tscn")
	if game_state == GAME_STATE_END_OF_DAY:
		var _change = get_tree().change_scene("res://Scenes/EndGames/EndOfDay.tscn")
	if game_state == GAME_STATE_TOO_HOT:
		var _change = get_tree().change_scene("res://Scenes/EndGames/Icecream.tscn")
