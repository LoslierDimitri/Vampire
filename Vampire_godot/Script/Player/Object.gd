extends Spatial

onready var main_node = get_tree().root.get_node("Main")
onready var player_node = main_node.get_node("Player_actual")

onready var POSITION_LAUNCH = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Position_launch")
onready var POSITION_LAUNCH_TARGET = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Position_launch_target")
onready var RAYCAST = player_node.get_node("Camera_pivot").get_node("Camera").get_node("Raycast")

onready var GRENADE_EXPLOSIVE = load("res://Object/Grenade_explosive.tscn")
onready var GRENADE_STUN = load("res://Object/Grenade_stun.tscn")
onready var MINE_EXPLOSION = load("res://Object/Mine_explosive.tscn")
onready var MINE_STUN = load("res://Object/Mine_stun.tscn")

export var grenade_explosive_launch_force = 20

export var grenade_stun_launch_force = 20

export var mine_explosive_max_range = 5

export var mine_stun_max_range = 5

var gun_list

##########################################################################
func action(object_name):
	##########################################################################
	if (object_name == "None"):
		print("action none")
	
	##########################################################################
	if (object_name == "Grenade_explosive"):
		print("action grenade_explosion")
		
		var grenade_explosive_instance = GRENADE_EXPLOSIVE.instance()
		grenade_explosive_instance.global_transform.origin = POSITION_LAUNCH.global_transform.origin
		grenade_explosive_instance.apply_impulse(self.global_transform.origin, (POSITION_LAUNCH_TARGET.global_transform.origin - POSITION_LAUNCH.global_transform.origin) * grenade_explosive_launch_force)
		main_node.add_child(grenade_explosive_instance)
	
	##########################################################################
	if (object_name == "Grenade_stun"):
		print("action Grenade_stun")
		
		var grenade_stun_instance = GRENADE_STUN.instance()
		grenade_stun_instance.global_transform.origin = POSITION_LAUNCH.global_transform.origin
		grenade_stun_instance.apply_impulse(self.global_transform.origin, (POSITION_LAUNCH_TARGET.global_transform.origin - POSITION_LAUNCH.global_transform.origin) * grenade_stun_launch_force)
		main_node.add_child(grenade_stun_instance)
	
	##########################################################################
	if (object_name == "Mine_explosive"):
		print("action Mine_explosive")
		
		RAYCAST.force_raycast_update()
		if !RAYCAST.is_colliding():
			return
		
		var collider = RAYCAST.get_collider()
		if (collider.is_in_group("No_collision") == true):
			return
		if (RAYCAST.get_collision_point().distance_to(self.global_transform.origin) < mine_explosive_max_range):
			var mine_explosion_instance = MINE_EXPLOSION.instance()
			mine_explosion_instance.global_transform.origin = RAYCAST.get_collision_point()
			main_node.add_child(mine_explosion_instance)
	
	##########################################################################
	if (object_name == "Mine_stun"):
		print("action Mine_stun")
		
		RAYCAST.force_raycast_update()
		if !RAYCAST.is_colliding():
			return
		
		var collider = RAYCAST.get_collider()
		if (collider.is_in_group("No_collision") == true):
			return
		if (RAYCAST.get_collision_point().distance_to(self.global_transform.origin) < mine_stun_max_range):
			var mine_stun_instance = MINE_STUN.instance()
			mine_stun_instance.global_transform.origin = RAYCAST.get_collision_point()
			main_node.add_child(mine_stun_instance)
	
	##########################################################################
	if (object_name == "Gun"):
		print("action Gun")
		
	
	##########################################################################
	if (object_name == "Crossbow_bolt"):
		print("action Crossbow_bolt")
		
	
	##########################################################################
	if (object_name == "Crossbow_stun"):
		print("action Crossbow_stun")
		
	
	##########################################################################
	if (object_name == "Hacking_tool"):
		print("action Hacking_tool")
		
		

func _on_Area_gun_body_entered(body):
	pass # Replace with function body.

func _on_Area_gun_body_exited(body):
	pass # Replace with function body.
