extends KinematicBody2D

signal shook_free(direction)

onready var Controls = get_node("/root/Controls")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 300
var current_movement_direction = Vector2.ZERO
var ignore_movement_input = false
var finished = false
export var allow_debug = false
onready var parent_node = get_node("..")

# Called when the node enters the scene tree for the first time.
func _ready():
	Controls.connect("player_move", self, "_on_Controls_player_move")
	for N in get_node("/root/rough-map/Enemies").get_children():
		if "HallMonitor" in N.name:
			N.connect("target_grabbed", self, "_on_target_grabbed")
			N.connect("target_dropped", self, "_on_target_dropped")
			N.connect("target_placed", self, "_on_target_placed")


func _physics_process(_delta):
	if allow_debug:
		ignore_movement_input = false
		finished = false
	
	if not allow_debug and not get_node("..") ==  parent_node:
		$CollisionShape2D.disabled = true
		$InteractionRadius.monitorable = false
	else:
		$CollisionShape2D.disabled = false
		$InteractionRadius.monitorable = true
		if not current_movement_direction == Vector2.ZERO:
			var _velocity = move_and_slide (current_movement_direction * speed)
			current_movement_direction = Vector2.ZERO


func _on_Controls_player_move(direction):
	if finished:
		return
	elif not ignore_movement_input:
		current_movement_direction += direction
	else:
		emit_signal("shook_free", direction)


func _on_target_placed(_DropTarget):
	print("Done!")
	finished = true
	ignore_movement_input = true
	$CollisionShape2D.disabled = true
	$InteractionRadius.monitorable = false
	position = Vector2(0,0)
	
	
func _on_target_grabbed():
	print("Grabbed!")
	ignore_movement_input = true
	$CollisionShape2D.disabled = true
	$InteractionRadius.monitorable = false


func _on_target_dropped():
	print("Broke Free!")
	$CollisionShape2D.disabled = false
	$InteractionRadius.monitorable = true
	ignore_movement_input = false
