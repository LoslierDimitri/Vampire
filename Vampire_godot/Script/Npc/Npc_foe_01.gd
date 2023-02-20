extends KinematicBody

onready var main_node = get_tree().root.get_node("Main")

onready var NAVIGATION_AGENT = get_node("Navigation_follow")

export var speed = 5

var target_pathfinding
var target_reachable = false
var target_close = false

var direction = Vector3()

func _ready():
	NAVIGATION_AGENT.change_pathfinding(main_node.get_node("Player_actual"))

func _physics_process(delta):
	direction = Vector3()
	direction = NAVIGATION_AGENT.pathfinding(target_pathfinding, delta)
	direction *= speed
	
	if (direction != null):
		if (target_reachable == true and target_close == false):
			move_and_collide(direction)
