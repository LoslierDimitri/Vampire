extends Control

onready var main_node = get_parent()

func _ready():
	get_tree().paused = false

func _on_Button_continue_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_NO, Input.MOUSE_MODE_CAPTURED, "MENU_NO", false)

func _on_Button_save_pressed():
	main_node.get_node("Save_load").save_file(main_node.PROFIL)

func _on_Button_load_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_LOAD_GAME_PROFIL_SELECTED, Input.MOUSE_MODE_VISIBLE, "MENU_LOAD_GAME_PROFIL_SELECTED", true)

func _on_Button_exit_pressed():
	main_node.remove_scene("Map_actual")
	main_node.remove_scene("Player_actual")
	
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_MAIN, Input.MOUSE_MODE_VISIBLE, "MENU_MAIN", true)

func _on_Button_option_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_PAUSE, main_node.INTERFACE_MENU_OPTION_GAMEPLAY, Input.MOUSE_MODE_VISIBLE, "MENU_OPTION_GAMEPLAY", true)
