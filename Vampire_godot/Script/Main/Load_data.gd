extends Spatial

onready var main_node = get_parent()

var dictionary

var map_actual
var player_position
var player_orientation

func update():
	update_player()
	update_map()

func update_map():
	if (main_node.get_node("Map_actual") != null):
		main_node.remove_scene("Map_actual")
	main_node.load_scene_map("res://Map/" + map_actual + ".tscn", "Map_actual", map_actual)

func update_player():
	if (main_node.get_node("Player_actual") != null):
		main_node.remove_scene("Player_actual")
	main_node.load_scene_player("res://Player/Player.tscn", "Player_actual")
	var player = main_node.get_node("Player_actual")
	player.global_transform.origin = player_position
	player.rotation_degrees = player_orientation

func deserialize(file_name):
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, File.READ)

		dictionary = file.get_var()
		file.close()
	
	map_actual = dictionary["Map_actual"]
	player_position = dictionary["Player_position"]
	player_orientation = dictionary["Player_orientation"]
