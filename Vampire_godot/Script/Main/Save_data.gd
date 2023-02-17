extends Spatial

onready var main_node = get_parent()

var dictionary

var map_actual
var player_position
var player_orientation

func update():
	update_map()
	update_player()

func update_map():
	map_actual = main_node.map_actual

func update_player():
	player_position = main_node.get_node("Player_actual").global_transform.origin
	player_orientation = Vector3(main_node.get_node("Player_actual").CAMERA_PIVOT.rotation_degrees.x, main_node.get_node("Player_actual").rotation_degrees.y, 0) 

func serialize():
	dictionary = {
		"Map_actual" : map_actual,
		"Player_position" : player_position,
		"Player_orientation" : player_orientation,
	}
	
	return dictionary
