extends RigidBody

export var scale_object = 0.1
onready var MESH = get_node("MeshInstance")
onready var COLLISION = get_node("CollisionShape")

onready var TIMER = get_node("Timer")

func _ready():
	MESH.scale.x = scale_object
	MESH.scale.y = scale_object
	MESH.scale.z = scale_object
	COLLISION.scale.x = scale_object
	COLLISION.scale.y = scale_object
	COLLISION.scale.z = scale_object
	
	TIMER.start()

func damage():
	pass

func _on_Timer_timeout():
	damage()
	queue_free()
