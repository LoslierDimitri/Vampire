extends KinematicBody

onready var main_node = get_tree().root.get_node("Main")

onready var NAVIGATION_AGENT = get_node("NavigationAgent")
#onready var TARGET = main_node.get_node("Map_actual").get_node("NavigationMeshInstance").get_node("TARGET")
#onready var TARGET = main_node.get_node("Player_actual")

func _ready():
	pass
#	print(TARGET)
#	return
#	NAVIGATION_AGENT.set_target_location(TARGET.global_transform.origin)

func _physics_process(delta):
	var TARGET = main_node.get_node("Player_actual")
	NAVIGATION_AGENT.set_target_location(TARGET.global_transform.origin)
	var next = NAVIGATION_AGENT.get_next_location()
	var velocity = (next - global_transform.origin).normalized() * 10 * delta
#	move_and_collide(velocity)
#	var snap_vector = -get_floor_normal()
#	move_and_slide_with_snap(velocity, snap_vector, Vector3.UP)
#	move_and_slide(velocity, Vector3.UP)
#	move_and_collide(velocity)
	translate(velocity)
