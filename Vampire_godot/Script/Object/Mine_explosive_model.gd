extends MeshInstance

onready var main_node = get_tree().root.get_node("Main")
var map_node

export var mesh_scale_object = 0.1

onready var AREA_DETECTION_COLLISION = get_node("Area_detection/Area_detection_collision")
onready var RANGE_DETECTION = get_node("Range_detection")

export var damage = 100
export var type = "damage"
export var range_detection = 5
export var range_explosion = 7

func _ready():
	self.scale.x = mesh_scale_object
	self.scale.y = mesh_scale_object
	self.scale.z = mesh_scale_object
	AREA_DETECTION_COLLISION.scale.x = range_detection / mesh_scale_object
	AREA_DETECTION_COLLISION.scale.y = range_detection / mesh_scale_object
	AREA_DETECTION_COLLISION.scale.z = range_detection / mesh_scale_object
	RANGE_DETECTION.scale.x = range_detection / mesh_scale_object
	RANGE_DETECTION.scale.y = range_detection / mesh_scale_object
	RANGE_DETECTION.scale.z = range_detection / mesh_scale_object

func damage():
	map_node = main_node.get_node("Map_actual")
	var npc_foe_node = map_node.get_node("Npc_foe")
	var npc_neutral_node = map_node.get_node("Npc_neutral")
	
	explosion(npc_foe_node)
	explosion(npc_neutral_node)
	explosion_player()

func explosion(npc_node):
	for node in npc_node.get_children():
		if (node.global_transform.origin.distance_to(global_transform.origin) <= range_explosion):
				if (node.is_in_group("Can_take_damage") == true):
					node.take_damage(damage, type)

func explosion_player():
	var player_node = main_node.get_node("Player_actual")
	if (player_node.global_transform.origin.distance_to(global_transform.origin) <= range_explosion):
			player_node.take_damage(damage, type)

func _on_Area_detection_body_entered(body):
	if (body.is_in_group("Npc") == true):
		damage()
		queue_free()
