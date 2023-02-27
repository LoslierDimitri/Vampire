extends Spatial

onready var main_node = get_tree().root.get_node("Main")
onready var player_node = main_node.get_node("Player_actual")
onready var ability_node = player_node.get_node("Ability")

onready var BLOOD_LANCE = load("res://Ability/Blood_lance_model.tscn")
onready var TIMER = get_node("Timer")

export var type = "damage"
export var damage = 50

export var timer = 2

func _ready():
	TIMER.set_wait_time(timer)

func damage(raycast):
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		return
	
	var blood_lance_instance = BLOOD_LANCE.instance()
	blood_lance_instance.timer = timer
	
	var collider = raycast.get_collider()
	var collision_position = raycast.get_collision_point()
	ability_node.teleport_position = collision_position
	if (collider.is_in_group("Can_take_damage") == true):
		collider.take_damage(damage, type)
		collider.add_child(blood_lance_instance)
	else:
		blood_lance_instance.global_transform.origin = collision_position
		blood_lance_instance.look_at_from_position(collision_position, raycast.global_transform.origin - blood_lance_instance.global_transform.origin, Vector3.UP)
		main_node.add_child(blood_lance_instance)
	
	
