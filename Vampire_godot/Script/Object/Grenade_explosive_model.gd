extends RigidBody

onready var main_node = get_tree().root.get_node("Main")
var map_node

export var scale_object = 0.1
onready var MESH = get_node("MeshInstance")
onready var COLLISION = get_node("CollisionShape")
onready var TIMER = get_node("Timer")
onready var RANGE_EXPLOSION = get_node("Range_explosion")

export var type = "damage"
export var damage = 50
export var explosion_range = 5
export var timer_time = 3

func _ready():
	MESH.scale.x = scale_object
	MESH.scale.y = scale_object
	MESH.scale.z = scale_object
	COLLISION.scale.x = scale_object
	COLLISION.scale.y = scale_object
	COLLISION.scale.z = scale_object
	RANGE_EXPLOSION.scale.x = explosion_range
	RANGE_EXPLOSION.scale.y = explosion_range
	RANGE_EXPLOSION.scale.z = explosion_range
	
	TIMER.set_wait_time(timer_time)
	TIMER.start()

func damage():
	map_node = main_node.get_node("Map_actual")
	var npc_foe_node = map_node.get_node("Npc_foe")
	var npc_neutral_node = map_node.get_node("Npc_neutral")
	
	explosion(npc_foe_node)
	explosion(npc_neutral_node)
	explosion_player()

func explosion(npc_node):
	for node in npc_node.get_children():
		if (node.global_transform.origin.distance_to(global_transform.origin) <= explosion_range):
			if (node.is_in_group("Can_take_damage") == true):
				node.take_damage(damage, type)

func explosion_player():
	var player_node = main_node.get_node("Player_actual")
	if (player_node.global_transform.origin.distance_to(global_transform.origin) <= explosion_range):
			player_node.take_damage(damage, type)

func _on_Timer_timeout():
	damage()
	queue_free()
