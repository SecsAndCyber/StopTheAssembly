extends "res://Scripts/Superclasses/WalkingCharacter.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var MoveTarget : Node2D = $Chair
onready var DeskObject : Node2D = $DeskSprite
var MoveTargetLocation : Vector2
var DeskLocation : Vector2
var done = false
# Called when the node enters the scene tree for the first time.
func _ready():
	MoveTargetLocation = MoveTarget.global_position
	DeskLocation = DeskObject.global_position
	speed = (randi() % 100)+25
	navigation_agent.set_target_location(MoveTarget.global_position)

func _physics_process(_delta):
	if done:
		return
	if not navigation_agent.is_navigation_finished():
		TryNavigationStep()
		MoveTarget.global_position = MoveTargetLocation
		navigation_agent.set_target_location(MoveTarget.global_position)
	DeskObject.global_position = DeskLocation
