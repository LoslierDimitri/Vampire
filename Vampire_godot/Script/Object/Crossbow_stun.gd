extends StaticBody

export var type = "stun"
export var damage = 1

func damage(raycast):
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		return
	
	var collider = raycast.get_collider()
	print(collider)
	var collision_position = raycast.get_collision_point()
	if (collider.is_in_group("Can_take_stun") == true):
		collider.take_damage(damage, type)
