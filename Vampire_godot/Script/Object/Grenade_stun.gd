extends Spatial

onready var main_node = get_tree().root.get_node("Main")

onready var GRENADE_STUN = load("res://Object/Grenade_stun_model.tscn")

export var grenade_stun_launch_force = 20

func damage(position_launch, position_launch_target):
	var grenade_stun_instance = GRENADE_STUN.instance()
	grenade_stun_instance.global_transform.origin = position_launch.global_transform.origin
	grenade_stun_instance.apply_impulse(grenade_stun_instance.global_transform.origin, (position_launch_target.global_transform.origin - position_launch.global_transform.origin) * grenade_stun_launch_force)
	main_node.add_child(grenade_stun_instance)
