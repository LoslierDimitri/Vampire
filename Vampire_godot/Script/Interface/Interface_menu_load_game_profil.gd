extends Control

onready var main_node = get_parent()

func _ready():
	pass

func _on_Button_exit_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_LOAD_GAME_PROFIL, main_node.INTERFACE_MENU_MAIN, Input.MOUSE_MODE_VISIBLE, "MENU_MAIN", true)

func _on_Button_profil_1_pressed():
	main_node.get_node("Save_load").load_file(1)

func _on_Button_profil_2_pressed():
	main_node.get_node("Save_load").load_file(2)

func _on_Button_profil_3_pressed():
	main_node.get_node("Save_load").load_file(3)
