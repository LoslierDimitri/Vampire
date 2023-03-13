extends Spatial

onready var main_node = get_parent()
onready var player_node_last_position = get_node("Player_last_position")

var player_node

func update_player_last_position():
	player_node = main_node.get_node("Player_actual")
	player_node_last_position.global_transform.origin = player_node.global_transform.origin
