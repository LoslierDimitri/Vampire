extends KinematicBody

onready var main_node = get_tree().root.get_node("Main")

onready var NAVIGATION_AGENT = get_node("NavigationAgent")

export var speed = 5

var target_reachable = false
export var target_reachable_distance = 5
var target_close = false
export var target_close_distance = 5

func _ready():
	pass

func _physics_process(delta):
	var TARGET = main_node.get_node("Player_actual")
	NAVIGATION_AGENT.set_target_location(TARGET.global_transform.origin)
	var next = NAVIGATION_AGENT.get_next_location()
	var velocity = (next - global_transform.origin).normalized() * speed * delta
	
	var target_position = TARGET.global_transform.origin
	var final_position = NAVIGATION_AGENT.get_final_location()
	
	if (target_position.distance_to(final_position) > target_reachable_distance):
		target_reachable = false
	else:
		target_reachable = true
	
	if (target_position.distance_to(global_transform.origin) < target_close_distance):
		target_close = true
	else:
		target_close = false
	
	if (target_reachable == true and target_close == false):
		translate(velocity)
