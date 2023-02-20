extends StaticBody

export var type = "damage"
export var damage = 50

func damage(raycast):
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		return
	
	var collider = raycast.get_collider()
	print(collider)
	var collision_position = raycast.get_collision_point()
	if (collider.is_in_group("Can_take_damage") == true):
		collider.take_damage(damage, type)
