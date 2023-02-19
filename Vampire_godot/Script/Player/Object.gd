extends Spatial

onready var main_node = get_tree().root.get_node("Main")
onready var player_node = main_node.get_node("Player_actual")

onready var POSITION_LAUNCH = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Position_launch")
onready var POSITION_LAUNCH_TARGET = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Position_launch_target")

onready var GRENADE_EXPLOSIVE = load("res://Object/Grenade_explosive.tscn")
onready var GRENADE_STUN = load("res://Object/Grenade_stun.tscn")

export var grenade_explosive_launch_force = 20

func action(object_name):
	if (object_name == "None"):
		print("action none")
		
	if (object_name == "Grenade_explosive"):
		print("action grenade_explosion")
		
		var grenade_explosive_instance = GRENADE_EXPLOSIVE.instance()
		grenade_explosive_instance.global_transform.origin = POSITION_LAUNCH.global_transform.origin
		grenade_explosive_instance.apply_impulse(self.global_transform.origin, (POSITION_LAUNCH_TARGET.global_transform.origin - POSITION_LAUNCH.global_transform.origin) * grenade_explosive_launch_force)
		main_node.add_child(grenade_explosive_instance)
	
	if (object_name == "Grenade_stun"):
		print("action Grenade_stun")
		
		var grenade_stun_instance = GRENADE_STUN.instance()
		grenade_stun_instance.global_transform.origin = POSITION_LAUNCH.global_transform.origin
		grenade_stun_instance.apply_impulse(self.global_transform.origin, (POSITION_LAUNCH_TARGET.global_transform.origin - POSITION_LAUNCH.global_transform.origin) * grenade_explosive_launch_force)
		main_node.add_child(grenade_stun_instance)
	
	if (object_name == "Mine"):
		print("action Mine")
		
		
	if (object_name == "Gun"):
		print("action Gun")
		
		
	if (object_name == "Crossbow_bolt"):
		print("action Crossbow_bolt")
		
		
	if (object_name == "Crossbow_stun"):
		print("action Crossbow_stun")
		
		
	if (object_name == "Hacking_tool"):
		print("action Hacking_tool")
		
		
