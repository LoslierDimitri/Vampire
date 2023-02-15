extends Control

onready var main_node = get_parent()

func _ready():
	pass

func _on_Button_exit_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_NEW_GAME_PROFIL, main_node.INTERFACE_MENU_MAIN, Input.MOUSE_MODE_VISIBLE, "MENU_MAIN", true)

func _on_Button_profil_1_pressed():
	new_game(1)

func _on_Button_profil_2_pressed():
	new_game(2)

func _on_Button_profil_3_pressed():
	new_game(3)

func new_game(profil):
	main_node.load_scene("res://Map/Map_01.tscn", "Map_actual")
	main_node.load_scene("res://Player/Player.tscn", "Player_actual")
	
	var map_actual = get_parent().get_node("Map_actual")
	var initial_player_position = map_actual.get_node("Position_player_spawn")
	var player_actual = get_parent().get_node("Player_actual")
	player_actual.global_transform.origin = initial_player_position.global_transform.origin
	
	main_node.PROFIL = profil
	
	main_node.change_interface(main_node.INTERFACE_MENU_NEW_GAME_PROFIL, main_node.INTERFACE_MENU_NO, Input.MOUSE_MODE_CAPTURED, "MENU_NO", false)
