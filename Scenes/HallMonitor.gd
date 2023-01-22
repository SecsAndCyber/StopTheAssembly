extends "res://Scripts/WalkingCharacter.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal target_grabbed()
signal target_dropped()
signal target_placed()
signal path_changed(points)

var DragTarget : Node2D = null
var ChaseTarget : Node2D = null
var DragChild : Node2D = null
var DragChildParent : Node2D = null
var stunned = false
var returning = false
# Called when the node enters the scene tree for the first time.
func _ready():
	DragTarget = get_node('/root/rough-map/level-map/DragTarget')
	
	for N in get_node("/root/rough-map").get_children():
		if "Player" in N.name:
			N.connect("shook_free", self, "_on_Player_shook_free")
		if "HallMonitor" in N.name:
			N.connect("target_placed", self, "_on_target_placed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
var next_recompute = 0
func _process(_delta):
	if returning:
		navigation_agent.set_target_location(default_location)
		emit_signal("path_changed", navigation_agent.get_nav_path())
	elif null == DragChild:
		var overlap_areas = $AggroRadius.get_overlapping_areas ( )
		if overlap_areas.size() > 0:
			for overlap in overlap_areas:
				if "Player" == overlap.get_node('..').name:
					last_saw_target = OS.get_system_time_msecs() + 15*1000
					ChaseTarget = overlap.get_node('..')
					navigation_agent.set_target_location(ChaseTarget.global_position)
					emit_signal("path_changed", navigation_agent.get_nav_path())
					break
		if next_recompute < OS.get_system_time_msecs():
			next_recompute = OS.get_system_time_msecs() + 500
			if null == ChaseTarget:
				navigation_agent.set_target_location(default_location)
				emit_signal("path_changed", navigation_agent.get_nav_path())
			else:
				navigation_agent.set_target_location(ChaseTarget.global_position)
				emit_signal("path_changed", navigation_agent.get_nav_path())
	elif DragTarget:
		if global_position.distance_to(DragTarget.global_position) > 5:
			print("Dragging: ", global_position.distance_to(DragTarget.global_position))
			navigation_agent.set_target_location(DragTarget.global_position)
			emit_signal("path_changed", navigation_agent.get_nav_path())
		else:
			print("Done Moving!")
			self.remove_child(DragChild)
			DragTarget.add_child(DragChild)
			emit_signal("target_placed", DragTarget)
			_on_target_placed(DragTarget)
				
var last_saw_target = 0
func _physics_process(delta):
	navigation_agent.path_desired_distance = ceil(speed * delta)
	navigation_agent.target_desired_distance  = ceil(speed * delta)
	if ChaseTarget and null == DragChild:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, ChaseTarget.global_position)
		if "HallMonitor" in ChaseTarget.get_node("..").name:
			print(name, " Abandoned Player")
			ChaseTarget = null
			navigation_agent.set_target_location(default_location)
			emit_signal("path_changed", navigation_agent.get_nav_path())
		elif result:
			if not "Player" == result.collider.name:
				if last_saw_target < OS.get_system_time_msecs():
					print(name, " Lost Sight of Player")
					ChaseTarget = null
					navigation_agent.set_target_location(default_location)
					emit_signal("path_changed", navigation_agent.get_nav_path())
			else:
				last_saw_target = OS.get_system_time_msecs() + 15*1000
	
	if returning and not navigation_agent.is_navigation_finished():
		if position.distance_squared_to(default_location) > 2:
			TryNavigationStep()
		else:
			navigation_agent.set_target_location(self.position)
			returning = false
	elif not stunned and not navigation_agent.is_navigation_finished():
		TryNavigationStep()
		
		if null == DragChild:
			for x in range(get_slide_count()):
				if "Player" == get_slide_collision (x).collider.name:
					if null == DragChild:
						shake_velocity = Vector2.ZERO
						DragChild = get_slide_collision (x).collider
						emit_signal("target_grabbed")
						DragChildParent = DragChild.get_node('..')
						DragChildParent.remove_child(DragChild)
						DragChild.position = Vector2(0,0)
						self.add_child(DragChild)
						DragChild.position = Vector2(12,12)
		else:
			if position.distance_squared_to(DragTarget.global_position) < 2:
				print("Done Moving!")
				self.remove_child(DragChild)
				DragTarget.add_child(DragChild)
				emit_signal("target_placed", DragTarget)
				_on_target_placed(DragTarget)
						
			elif shake_velocity.length() > 10*shake_threshold:
				print("Break Free!")
				DragChild.move_and_slide( shake_velocity )
				var child_location = DragChild.global_position
				self.remove_child(DragChild)
				DragChildParent.add_child(DragChild)
				DragChild.position = DragChild.to_local(child_location)
				DragChild = null
				ChaseTarget = null
				emit_signal("target_dropped")
				$CollisionShape2D.disabled = true
				stunned = true
				yield(get_tree().create_timer(2), "timeout")
				stunned = false
				$CollisionShape2D.disabled = false

var shake_velocity = Vector2.ZERO
export var shake_threshold = 5
func _on_Player_shook_free(direction):
	if not DragChild == null:
		shake_velocity += direction
		print("Shaking:", shake_velocity)
	
func _on_target_placed(_DropTarget):
	returning = true
	DragChild = null
	ChaseTarget = null
	DragTarget = null
	if default_location.distance_squared_to(position) > 2:
		navigation_agent.set_target_location(default_location)
