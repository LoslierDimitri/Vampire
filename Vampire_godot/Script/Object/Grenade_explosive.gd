extends Spatial

onready var main_node = get_tree().root.get_node("Main")

onready var GRENADE_EXPLOSIVE = load("res://Object/Grenade_explosive_model.tscn")

export var grenade_explosive_launch_force = 20

func damage(position_launch, position_launch_target):
	var grenade_explosive_instance = GRENADE_EXPLOSIVE.instance()
	grenade_explosive_instance.global_transform.origin = position_launch.global_transform.origin
	grenade_explosive_instance.apply_impulse(grenade_explosive_instance.global_transform.origin, (position_launch_target.global_transform.origin - position_launch.global_transform.origin) * grenade_explosive_launch_force)
	main_node.add_child(grenade_explosive_instance)
