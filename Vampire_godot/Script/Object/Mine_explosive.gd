extends Spatial

onready var main_node = get_tree().root.get_node("Main")
var map_node

onready var MINE_EXPLOSION = load("res://Object/Mine_explosive_model.tscn")

export var mine_explosive_max_range = 5

func damage(raycast):
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		return
	
	var collider = raycast.get_collider()
	if (raycast.get_collision_point().distance_to(raycast.global_transform.origin) < mine_explosive_max_range):
		var mine_explosion_instance = MINE_EXPLOSION.instance()
		mine_explosion_instance.global_transform.origin = raycast.get_collision_point()
		main_node.add_child(mine_explosion_instance)
