extends Spatial

onready var main_node = get_tree().root.get_node("Main")

onready var BLOOD_LANCE = load("res://Ability/Blood_lance_model.tscn")

export var type = "damage"
export var damage = 50

export var timer = 2

func damage(raycast):
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		return
	
#	var position = raycast.get_collision_point()
	var blood_lance_instance = BLOOD_LANCE.instance()
#	collider.add_child(blood_lance_instance)
	
	var collider = raycast.get_collider()
#	print(collider)
	var collision_position = raycast.get_collision_point()
	if (collider.is_in_group("Can_take_damage") == true):
		collider.take_damage(damage, type)
		collider.add_child(blood_lance_instance)
	else:
		blood_lance_instance.global_transform.origin = collision_position
#		blood_lance_instance.look_at(main_node.get_node("Player_actual").global_transform.origin - blood_lance_instance.global_transform.origin, Vector3.UP)
		main_node.add_child(blood_lance_instance)
	
	
