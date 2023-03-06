extends Spatial

onready var main_node = get_tree().root.get_node("Main")
onready var map_node = main_node.get_node("Map_actual")
onready var npc_foe_node = map_node.get_node("Npc_foe")
onready var npc_neutral_node = map_node.get_node("Npc_neutral")

var blood_link_list = []
var max_blood_link = 4
var actual_blood_link = 0

func blood_link(raycast):
	clean_blood_link_list()
	
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		return
	
	var collider = raycast.get_collider()
	if (collider.is_in_group("Can_take_blood_link") == true):
		if (collider.is_blood_link == false):
			if (actual_blood_link < max_blood_link):
				collider.is_blood_link = true
				blood_link_list.append(collider)
		else:
			collider.is_blood_link = false
			blood_link_list.erase(collider)
	
	print(blood_link_list)
	print(blood_link_list.size())

func clean_blood_link_list():
	actual_blood_link = 0
	blood_link_list = []
	
	for node in npc_foe_node.get_children():
		if (node.is_blood_link == true):
			blood_link_list.append(node)
			actual_blood_link += 1
	for node in npc_neutral_node.get_children():
		if (node.is_blood_link == true):
			blood_link_list.append(node)
			actual_blood_link += 1 
