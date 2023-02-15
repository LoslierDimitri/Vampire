extends Control

onready var main_node = get_parent()

func _ready():
	pass

func _on_Button_exit_pressed():
	main_node.change_interface(main_node.INTERFACE_MENU_LOAD_GAME_PROFIL, main_node.INTERFACE_MENU_MAIN, Input.MOUSE_MODE_VISIBLE, "MENU_MAIN", true)

func _on_Button_profil_1_pressed():
	pass # Replace with function body.

func _on_Button_profil_2_pressed():
	pass # Replace with function body.

func _on_Button_profil_3_pressed():
	pass # Replace with function body.
