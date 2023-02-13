extends Control

onready var main_node = get_parent()

func _ready():
	pass

func _on_Button_play_pressed():
	main_node.load_scene("res://Map/Map_01.tscn", "Map_actual")
	main_node.load_scene("res://Player/Player.tscn", "Player_actual")
	
	var map_actual = get_parent().get_node("Map_actual")
	var initial_player_position = map_actual.get_node("Position_player_spawn")
	var player_actual = get_parent().get_node("Player_actual")
	player_actual.global_transform.origin = initial_player_position.global_transform.origin
	
	main_node.STATE = "IN_GAME"
	main_node.INTERFACE_MENU_MAIN.visible = false

func _on_Button_load_pressed():
	pass

func _on_Button_exit_pressed():
	get_tree().quit()
