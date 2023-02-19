extends RigidBody

export var scale_object = 0.1
onready var MESH = get_node("MeshInstance")
onready var COLLISION = get_node("CollisionShape")
onready var AREA_STICK_COLLISION = get_node("Area_stick/Area_stick_collision")

var body_hacked

func _ready():
	MESH.scale.x = scale_object
	MESH.scale.y = scale_object
	MESH.scale.z = scale_object
	COLLISION.scale.x = scale_object
	COLLISION.scale.y = scale_object
	COLLISION.scale.z = scale_object
	AREA_STICK_COLLISION.scale.x = scale_object
	AREA_STICK_COLLISION.scale.y = scale_object
	AREA_STICK_COLLISION.scale.z = scale_object

func damage():
	pass

func _on_Area_stick_body_entered(body):
	if (body.is_in_group("No_collision") == false):
		set_mode(MODE_STATIC)
		body_hacked = body
