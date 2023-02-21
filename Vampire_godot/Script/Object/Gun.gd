extends StaticBody

onready var main_node = get_tree().root.get_node("Main")
var map_node
var player_node
var gun_position

export var damage = 40
export var type = "damage"

func _ready():
	player_node = main_node.get_node("Player_actual")

func damage(gun_list):
	for node in gun_list:
		var space_state = get_world().direct_space_state
		gun_position = player_node.get_node("Camera_pivot").get_node("Camera").global_transform.origin
		var result = space_state.intersect_ray(gun_position, node.global_transform.origin)
		
		if (result):
			print(result.collider)
			if (result.collider == node):
				if (node.is_in_group("Can_take_damage") == true and node.is_in_group("Player") == false):
					node.take_damage(damage, type)
