extends RigidBody

export var mesh_scale_object = 0.1
export var collision_scale_object = 0.001
onready var MESH = get_node("MeshInstance")
onready var COLLISION = get_node("CollisionShape")

func _ready():
	MESH.scale.x = mesh_scale_object
	MESH.scale.y = mesh_scale_object
	MESH.scale.z = mesh_scale_object
	COLLISION.scale.x = collision_scale_object
	COLLISION.scale.y = collision_scale_object
	COLLISION.scale.z = collision_scale_object
	
	set_mode(MODE_STATIC)

func damage():
	pass

func _on_Timer_timeout():
	damage()
	queue_free()

func _on_Area_body_entered(body):
	pass # Replace with function body.
