extends KinematicBody2D

export var speed = 100.0
onready var navigation_agent = $NavigationAgent2D
onready var default_location = global_position


# Called when the node enters the scene tree for the first time.
func _ready():
	navigation_agent.set_navigation_map (get_node('/root/rough-map/level-map/NavigationPolygonInstance'))
	navigation_agent.set_target_location(default_location)


func TryNavigationStep():
	var next_step = navigation_agent.get_next_location()
	var destination = navigation_agent.get_final_location ( )
	var target = position.direction_to(next_step)
	var step_speed = min(speed, global_position.distance_squared_to(destination))
	var _velocity = move_and_slide(target*step_speed)
	navigation_agent.set_velocity(_velocity)
	if _velocity.length_squared() < .001:
		for x in range(get_slide_count()):
			var collider = get_slide_collision (x).collider
			if "Door" in collider.name:
				collider.open = true
				break
			elif "wall" in collider.name:
				position += (-1 * position.direction_to(collider.global_position))
				break
			elif "Student" in collider.name:
				position += (-2 * position.direction_to(collider.global_position))
				break
			else:
				position += (-.5 * position.direction_to(collider.global_position))
				
		navigation_agent.set_target_location(destination)
	return _velocity
