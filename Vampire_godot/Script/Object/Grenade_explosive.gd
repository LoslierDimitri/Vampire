extends RigidBody

onready var main_node = get_tree().root.get_node("Main")
var map_node

export var scale_object = 0.1
onready var MESH = get_node("MeshInstance")
onready var COLLISION = get_node("CollisionShape")

onready var RAYCAST = get_node("RayCast")

onready var TIMER = get_node("Timer")

#var raycast
export var type = "damage"
export var damage = 50
export var explosion_range = 5

func _ready():
	MESH.scale.x = scale_object
	MESH.scale.y = scale_object
	MESH.scale.z = scale_object
	COLLISION.scale.x = scale_object
	COLLISION.scale.y = scale_object
	COLLISION.scale.z = scale_object
	
	TIMER.start()

func damage():
	map_node = main_node.get_node("Map_actual")
	var npc_foe_node = map_node.get_node("Npc_foe")
	var npc_neutral_node = map_node.get_node("Npc_neutral")
	
#	raycast = RayCast.new()
	RAYCAST.global_transform.origin = global_transform.origin
	RAYCAST.global_transform.origin.y += 2
#	raycast.translation = global_transform.origin
	
	explosion(npc_foe_node)
	explosion(npc_neutral_node)

func explosion(npc_node):
	for node in npc_node.get_children():
#		RAYCAST.set_cast_to((node.global_transform.origin - RAYCAST.global_transform.origin) * 100)
		RAYCAST.set_cast_to((RAYCAST.global_transform.origin - node.global_transform.origin) * 100)
#		RAYCAST.set_cast_to(node.global_transform.origin)
#		raycast.global_rotation = node.global_transform.origin - raycast.global_transform.origin
		RAYCAST.force_raycast_update()
#		RAYCAST.set_cast_to(RAYCAST.get_cast_to().normalized() * 100)
		var collider = RAYCAST.get_collider()
		
		print("grenade position: ", global_transform.origin)
		print("raycast position: ", RAYCAST.global_transform.origin)
		print("npc position: ", node.global_transform.origin)
		print("raycast cast to: ", RAYCAST.get_cast_to())
		print("collider: ", collider)
#		print("collider position: ", collider.global_transform.origin)
		print("node: ", node)
		
		if (collider == node):
			if (node.is_in_group("Can_take_damage") == true):
				node.take_damage(damage, type)

func _on_Timer_timeout():
	damage()
	queue_free()
