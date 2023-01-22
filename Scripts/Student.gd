extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 100.0
onready var navigation_agent = $NavigationAgent2D
onready var MoveTarget : Node2D = $Chair
var MoveTargetLocation : Vector2
var done = false
# Called when the node enters the scene tree for the first time.
func _ready():
	MoveTargetLocation = MoveTarget.global_position
	navigation_agent.set_navigation_map (get_node('/root/rough-map/level-map/NavigationPolygonInstance'))
	navigation_agent.set_target_location(MoveTarget.position)
	speed = (randi() % 100)+25

func _physics_process(_delta):
	if done:
		return
	MoveTarget.global_position = MoveTargetLocation
	if not navigation_agent.is_navigation_finished():
		var target = position.direction_to(navigation_agent.get_next_location())
		navigation_agent.set_velocity(target*speed)
		move_and_slide(target*speed)
		MoveTarget.global_position = MoveTargetLocation
		navigation_agent.set_target_location(MoveTarget.global_position)
