extends Control

onready var main_node = get_parent()

func _ready():
	pass

func _on_Button_play_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_MAIN, main_node.INTERFACE_MENU_NEW_GAME_PROFIL, Input.MOUSE_MODE_VISIBLE, "MENU_NEW_GAME_PROFIL", true)
	
func _on_Button_load_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_MAIN, main_node.INTERFACE_MENU_LOAD_GAME_PROFIL, Input.MOUSE_MODE_VISIBLE, "MENU__LOAD_GA%E_PROFIL", true)

func _on_Button_exit_pressed():
	get_tree().quit()

func _on_Button_option_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_MAIN, main_node.INTERFACE_MENU_OPTION_GAMEPLAY, Input.MOUSE_MODE_VISIBLE, "MENU_OPTION_GAMEPLAY", true)
