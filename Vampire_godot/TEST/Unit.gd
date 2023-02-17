extends KinematicBody

onready var Agent = get_node("Agent")
onready var Target = get_parent().get_node("NavigationMeshInstance/Target")

func _ready():
	Agent.set_target_location(Target.transform.origin)

func _physics_process(delta):
	var next = Agent.get_next_location()
	var velocity = (next - transform.origin).normalized() * 5
#	move_and_collide(velocity)
	move_and_slide_with_snap(velocity, Vector3.DOWN, Vector3.UP)
